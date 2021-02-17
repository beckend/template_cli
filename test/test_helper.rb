# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/cli'

# Add test libraries you want to use here, e.g. mocha
# Add helper classes or methods here, too
module TestHelper
  CLI = TemplateCLI::CLI

  PATHS = {
    fixtures: File.join([File.dirname(__FILE__), 'fixtures'])
  }.freeze
end
