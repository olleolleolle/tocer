require "spec_helper"

describe Tocer::Writer do
  subject { described_class.new test_path }

  describe "#insert", :temp_dir do
    let(:test_path) { File.join temp_dir, "test.md" }
    before { FileUtils.cp fixture_path, test_path }

    context "when table of contents exists and is empty" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "fixtures", "toc-empty.md" }
      let :contents do
        "# Introduction\n" \
        "\n" \
        "Once upon a time...\n" \
        "\n" \
        "<!-- Tocer[start]: Auto-generated, don't remove. -->\n" \
        "\n" \
        "# Table of Contents\n" \
        "\n"\
        "- [One](#one)\n" \
        "- [Two](#two)\n" \
        "- [Three](#three)\n" \
        "\n" \
        "<!-- Tocer[finish]: Auto-generated, don't remove. -->\n" \
        "\n" \
        "# One\n" \
        "# Two\n" \
        "# Three\n" \
        "\n" \
        "The end.\n"
      end

      it "replaces existing table of contents with new table of contents" do
        subject.write
        expect(File.open(test_path, "r").to_a.join).to eq(contents)
      end
    end

    context "when table of contents exists" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "fixtures", "toc-existing.md" }
      let :contents do
        "# Introduction\n" \
        "\n" \
        "Once upon a time...\n" \
        "\n" \
        "<!-- Tocer[start]: Auto-generated, don't remove. -->\n" \
        "\n" \
        "# Table of Contents\n" \
        "\n"\
        "- [One](#one)\n" \
        "- [Two](#two)\n" \
        "- [Three](#three)\n" \
        "\n" \
        "<!-- Tocer[finish]: Auto-generated, don't remove. -->\n" \
        "\n" \
        "# One\n" \
        "# Two\n" \
        "# Three\n" \
        "\n" \
        "The end.\n"
      end

      it "replaces existing table of contents with new table of contents" do
        subject.write
        expect(File.open(test_path, "r").to_a.join).to eq(contents)
      end
    end

    context "when table of contents doesn't exist" do
      let(:fixture_path) { File.join Dir.pwd, "spec", "fixtures", "toc-missing.md" }
      let :contents do
        "<!-- Tocer[start]: Auto-generated, don't remove. -->\n" \
        "\n" \
        "# Table of Contents\n" \
        "\n" \
        "- [One](#one)\n" \
        "- [Two](#two)\n" \
        "\n" \
        "<!-- Tocer[finish]: Auto-generated, don't remove. -->\n" \
        "\n" \
        "# One\n" \
        "# Two\n"
      end

      it "inserts table of contents to top of file" do
        subject.write
        expect(File.open(test_path, "r").to_a.join).to eq(contents)
      end
    end
  end
end