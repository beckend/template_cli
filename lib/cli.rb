# frozen_string_literal: true

require 'gli'
require_relative './app'

module TemplateCLI
  VERSION = '0.0.1'

  # Main CLI application
  class CLI
    def initialize
      @app = TemplateCLI::App.new
    end

    extend GLI::App

    program_desc 'Generate erubi templates with locals as string or json/yaml files.'

    version TemplateCLI::VERSION

    subcommand_option_handling :normal
    arguments :strict

    desc 'Generate erubi templates with locals as string or json/yaml files.'
    arg_name 'see generate --help for flags'
    command :generate do |c|
      c.flag(:source, { default_value: nil,
                        arg_name: '"/tmp/my-file.erb"',
                        type: String,
                        desc: 'Input template as string or filepath.' })
      c.flag(:locals, { default_value: nil,
                        arg_name: '"{ "list": [1, 2, 3, "hello"] }"',
                        type: String,
                        desc: 'Template locals/variables, accepts string or files or json or yaml contents.' })
      c.flag('file-output', { default_value: nil,
                              arg_name: '"/tmp/output-file"',
                              type: String,
                              desc: 'If provided will attempt to (over)write file to destination provided.' })

      c.action do |_global_options, options, _args|
        TemplateCLI::App::TASKS[:generate].call(options)
      end
    end

    pre do |_global, _command, _options, _args|
      # Pre logic here
      # Return true to proceed; false to abort and not call the
      # chosen command
      # Use skips_pre before a command to skip this block
      # on that command only
      true
    end

    post do |global, command, options, args|
      # Post logic here
      # Use skips_post before a command to skip this
      # block on that command only
    end

    on_error do |exception|
      print exception.backtrace.join("\n")
      true
    end
  end
end
