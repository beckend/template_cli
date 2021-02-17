# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
# rubocop:disable Style/StringConcatenation
# rubocop:disable Layout/ArrayAlignment

require_relative 'test_helper'

class TemplateLocalsFileTest < Minitest::Test
  def test_file_template_with_locals_file_json
    path_file_source = File.join([TestHelper::PATHS[:fixtures], 'erubi_with_locals_1.erb'])
    path_file_locals = File.join([TestHelper::PATHS[:fixtures], 'locals_1.json'])

    assert_output('<ul>
    <li>aaa</li>
    <li>213123</li>
    <li>ccc</li>
</ul>
') do
      TestHelper::CLI
        .run([
               'generate', '--source="' + path_file_source + '"',
                '--locals="' + path_file_locals + '"'
             ])
    end
  end

  def test_file_template_with_locals_file_yaml
    path_file_source = File.join([TestHelper::PATHS[:fixtures], 'erubi_with_locals_1.erb'])
    path_file_locals = File.join([TestHelper::PATHS[:fixtures], 'locals_1.yaml'])

    assert_output('<ul>
    <li>aaa</li>
    <li>213123</li>
    <li>ccc</li>
</ul>
') do
      TestHelper::CLI
        .run([
               'generate', '--source="' + path_file_source + '"',
                '--locals="' + path_file_locals + '"'
             ])
    end
  end
end

# rubocop:enable Metrics/MethodLength
# rubocop:enable Style/StringConcatenation
# rubocop:enable Layout/ArrayAlignment
