# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
# rubocop:disable Style/StringConcatenation

require_relative 'test_helper'

class TemplateLocalsStringTest < Minitest::Test
  def test_as_string_json_with_locals
    contents_fixture = File.read(File.join([TestHelper::PATHS[:fixtures], 'erubi_with_locals_1.erb']))
    contents_locals = File.read(File.join([TestHelper::PATHS[:fixtures], 'locals_1.json']))

    assert_output('<ul>
    <li>aaa</li>
    <li>213123</li>
    <li>ccc</li>
</ul>
') do
      TestHelper::CLI
        .run([
               'generate', '--source="' + contents_fixture + '"',
               '--locals="' + contents_locals + '"'
             ])
    end
  end

  def test_as_string_yaml_with_locals
    contents_fixture = File.read(File.join([TestHelper::PATHS[:fixtures], 'erubi_with_locals_1.erb']))
    contents_locals = File.read(File.join([TestHelper::PATHS[:fixtures], 'locals_1.yaml']))

    assert_output('<ul>
    <li>aaa</li>
    <li>213123</li>
    <li>ccc</li>
</ul>
') do
      TestHelper::CLI
        .run([
               'generate', '--source="' + contents_fixture + '"',
               '--locals="' + contents_locals + '"'
             ])
    end
  end

  def test_as_string_no_locals
    contents_fixture = File.read(File.join([TestHelper::PATHS[:fixtures], 'erubi_1.erb']))

    assert_output('<ul>
    <li>aaa</li>
    <li>213123</li>
    <li>ccc</li>
</ul>
') do
      TestHelper::CLI
        .run([
               'generate', '--source="' + contents_fixture + '"'
             ])
    end
  end
end

# rubocop:enable Metrics/MethodLength
# rubocop:enable Style/StringConcatenation
