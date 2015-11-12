require "yaml"
require "thor"
require "thor/actions"
require "thor_plus/actions"

module Tocer
  # The Command Line Interface (CLI) for the gem.
  class CLI < Thor
    include Thor::Actions
    include ThorPlus::Actions

    package_name Tocer::Identity.version_label

    def initialize args = [], options = {}, config = {}
      super args, options, config
    end

    desc "-e, [--edit]", "Edit #{Tocer::Identity.label} settings in default editor."
    map %w(-e --edit) => :edit
    def edit
      `#{editor} $HOME/#{Tocer::Identity.file_name}`
    end

    desc "-v, [--version]", "Show #{Tocer::Identity.label} version."
    map %w(-v --version) => :version
    def version
      say Tocer::Identity.version_label
    end

    desc "-h, [--help=HELP]", "Show this message or get help for a command."
    map %w(-h --help) => :help
    def help task = nil
      say && super
    end
  end
end
