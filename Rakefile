require 'rake/testtask'
require 'bundler/gem_tasks'

Rake::TestTask.new do |test|
  test.verbose = true
  test.libs << 'spec'
  test.test_files = FileList['spec/**/*_spec.rb']
end

task default: :test
