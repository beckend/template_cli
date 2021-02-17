# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
# rubocop:disable Style/StringConcatenation
# rubocop:disable Naming/VariableNumber

require_relative 'test_helper'
require 'fileutils'

class TemplateFileOutputTest < Minitest::Test
  def test_file_output_1
    contents_fixture = File.read(File.join([TestHelper::PATHS[:fixtures], 'erubi_1.erb']))

    assert_output('') do
      dir_target = '/tmp/_______delete_me______________'
      file_path_target = dir_target + '/dasjdnass/jhfdsygffdsf/fdsafasdf/output.txt'

      begin
        TestHelper::CLI
          .run([
                 'generate',
                 '--source="' + contents_fixture + '"',
                 '--file-output="' + file_path_target + '"'
               ])

        assert(File.exist?(file_path_target), true)
      ensure
        FileUtils.rm_r(dir_target, force: true)
      end
    end
  end
end

# rubocop:enable Metrics/MethodLength
# rubocop:enable Style/StringConcatenation
# rubocop:enable Naming/VariableNumber
