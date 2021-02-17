# frozen_string_literal: true

require 'rake/clean'
require 'rubygems'
require 'rubygems/package_task'
require 'rdoc/task'
require 'rake/testtask'

Rake::RDocTask.new do |rd|
  rd.main = 'README.rdoc'
  rd.rdoc_files.include('README.rdoc', 'lib/**/*.rb', 'bin/**/*')
  rd.title = 'template_cli'
end

spec = eval(File.read('template_cli.gemspec')) # rubocop:disable Security/Eval

Gem::PackageTask.new(spec) do |pkg|
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/*_test.rb']
end

task :build do
  sh 'gem build template_cli.gemspec'
end

task default: :test
