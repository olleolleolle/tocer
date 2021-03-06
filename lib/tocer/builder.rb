# frozen_string_literal: true

module Tocer
  # Builds a table of contents for a Markdown document.
  class Builder
    def initialize lines, label: "# Table of Contents", comment_block: Elements::CommentBlock
      @lines = lines
      @label = label
      @comment_block = comment_block.new
      @url_count = Hash.new { |hash, key| hash[key] = 0 }
    end

    def headers
      lines.select { |line| line.start_with? Parsers::Header.punctuation }
    end

    def build
      return "" if headers.empty?

      [
        "#{comment_block.start}\n\n",
        "#{label}\n\n",
        headers_as_links.join("\n"),
        "\n\n#{comment_block.finish}\n\n"
      ].join
    end

    private

    attr_reader :lines, :label, :comment_block, :url_count

    def acquire_transfomer header
      if header =~ /\[.+\]\(.+\)/
        Transformers::Link.new header
      else
        Transformers::Text.new header
      end
    end

    def url_suffix url
      url_count[url].zero? ? "" : url_count[url]
    end

    def transform header
      transformer = acquire_transfomer header
      link = transformer.transform url_suffix: url_suffix(transformer.url)
      url_count[transformer.url] += 1
      link
    end

    def headers_as_links
      headers.map { |header| transform header }
    end
  end
end
