require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'simplecov'
SimpleCov.start do
  add_filter 'spec'
end if ENV['COVERAGE']

require 'rspec/autorun'

def test_file(file_name)
  File.join(
    File.dirname(__FILE__), "dummy_files/#{file_name}.rb"
  )
end
