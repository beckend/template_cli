# frozen_string_literal: true

# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__), 'lib', 'cli.rb'])

Gem::Specification.new do |s|
  s.add_development_dependency('minitest', '~> 5.14')
  s.add_development_dependency('rake', '~> 0.9.2')
  s.add_development_dependency('rdoc', '~> 4.3')

  s.add_runtime_dependency('erubi', '~> 1.10')
  s.add_runtime_dependency('gli', '~> 2.20.0')
  s.add_runtime_dependency('nice_hash', '~> 1.17')
  s.add_runtime_dependency('tilt', '~> 2.0')

  s.author = 'Linken Dinh'
  s.bindir = 'bin'
  s.email = 'linken.dinh@gmail.com'
  s.executables << 'template_cli'
  s.extra_rdoc_files = ['README.rdoc', 'template_cli.rdoc']
  s.files = `git ls-files`.split("\n")
  s.homepage = 'https://linken.app'
  s.licenses = ['MIT']
  s.name = 'template_cli'
  s.platform = Gem::Platform::RUBY
  s.rdoc_options << '--title' << 'template_cli' << '--main' << 'README.rdoc' << '-ri'
  s.require_paths << 'lib'
  s.required_ruby_version = '>= 2.7.0'
  s.summary = 'Generate erubi templates with locals as string or json/yaml files.'
  s.version = TemplateCLI::VERSION
end
