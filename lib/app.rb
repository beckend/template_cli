# frozen_string_literal: true

require 'tempfile'
require 'nice_hash'
require 'yaml'
require 'tilt/erubi'
require 'erubi/capture_end'
require 'json'
require 'pathname'
require 'fileutils'
require 'etc'

module TemplateCLI
  # Main application
  class App # rubocop:disable Metrics/ClassLength
    TASKS = {
      generate: lambda { |options| # rubocop:disable Metrics/BlockLength
        source_read = App::GETTERS[:contents_from_file]
                      .call({
                              error_if_empty: true,
                              error_message: 'source need a string as input',
                              file_or_path: options[:source]
                            })

        options_sanitized = {
          locals: App::GETTERS[:locals].call(options[:locals]),
          source: source_read[:contents]
        }

        p options_sanitized

        # if source is a valid file read then no need to write to TempFile
        if source_read[:read_success]
          return App::UTILS[:return_template].call({
                                                     path_file_output: options['file-output'],
                                                     template_output: App::GETTERS[:template]
                                                     .call({
                                                             locals: options_sanitized[:locals],
                                                             source: source_read[:file_or_path_sanitized]
                                                           })
                                                   })
        end

        # need to write as TempFile
        file_tmp = App::GETTERS[:template_write_tmp].call(options_sanitized[:source])

        begin
          template_output = App::GETTERS[:template].call({ locals: options_sanitized[:locals], source: file_tmp.path })

          App::UTILS[:return_template].call({
                                              path_file_output: options['file-output'],
                                              template_output: template_output
                                            })
        ensure
          file_tmp.close
          file_tmp.unlink
        end
      }
    }.freeze

    GETTERS = {
      template: lambda { |options|
        Tilt::ErubiTemplate.new(options[:source], engine_class: Erubi::CaptureEndEngine)
                           .render(self, options[:locals])
      },

      contents_from_file: lambda { |options|
        if options[:error_if_empty]
          App::VALIDATORS[:string].call({ error_message: options[:error_message] || 'Empty contents is not permitted.',
                                          value: options[:file_or_path] })
        end

        file_or_path_sanitized = App::UTILS[:sanitize_arg].call(options[:file_or_path])
        file_or_path_sanitized = file_or_path_sanitized.start_with?('~') ? file_or_path_sanitized.sub!('~', Etc.getpwuid.dir) : file_or_path_sanitized # rubocop:disable Layout/LineLength

        begin
          contents = File.read(file_or_path_sanitized)

          return {
            contents: contents,
            file_or_path_sanitized: file_or_path_sanitized,
            read_success: true
          }
        rescue StandardError
          return {
            contents: file_or_path_sanitized,
            file_or_path_sanitized: file_or_path_sanitized,
            read_success: false
          }
        end
      },

      locals: lambda { |locals_string_or_filepath|
        return locals_string_or_filepath if locals_string_or_filepath.nil? || locals_string_or_filepath.empty?

        file_read = App::GETTERS[:contents_from_file]
                    .call({ file_or_path: locals_string_or_filepath })

        # handle json since ruby escapes the string and it causes issues
        begin
          json_payload = App::VALIDATORS[:valid_json]
                         .call(file_read[:contents])
          raise StandardError 'Not valid json.' unless json_payload[:success]

          return json_payload[:json]
        rescue StandardError
          # attempt to load as yaml
          template_value = YAML.safe_load(file_read[:contents])

          unless template_value
            raise StandardError,
                  'Template load as yaml failed'
          end

          return template_value.to_json.json
        end
      },

      template_write_tmp: lambda { |contents|
        file = Tempfile.new(['template_tmp', '.txt'])
        file.write(contents)
        # have to flush it for contents to be available for other functions.
        file.flush
        file
      },

      sanitized_file_read_contents: lambda { |x|
        x.gsub! '\"', '"'
      }
    }.freeze

    VALIDATORS = {
      string: lambda { |x|
        raise StandardError, x.error_message if x.nil? || x.empty?

        x
      },

      valid_json: lambda { |x|
        begin
          return {
            json: JSON.parse(x),
            success: true
          }
        rescue StandardError
          {
            json: nil,
            success: false
          }
        end
      }

    }.freeze

    UTILS = {
      return_template: lambda { |options|
        path_output_sanitized = options[:path_file_output] ? App::UTILS[:sanitize_arg].call(options[:path_file_output]) : nil

        if options[:path_file_output]
          FileUtils.mkdir_p(File.dirname(path_output_sanitized))

          File.open(path_output_sanitized, 'w') do |file_out|
            file_out.write(options[:template_output])
            file_out.close
          end
        else
          puts options[:template_output]
        end
      },

      sanitize_arg: lambda { |x|
        return x if x.nil? || x.empty?

        returned = x

        if returned.start_with?('"') && returned.end_with?('"')
          returned = returned.delete_prefix('"').delete_suffix('"')
        end

        if returned.start_with?("'") && returned.end_with?("'")
          returned = returned.delete_prefix("'").delete_suffix("'")
        end

        returned
      }
    }.freeze
  end
end
