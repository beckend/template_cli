# frozen_string_literal: true

require_relative('./cli')

exit TemplateCLI::CLI.run(ARGV)
