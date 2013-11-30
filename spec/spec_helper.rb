require 'rspec/autorun'

def test_file_path(file_name)
  File.join(
    File.dirname(__FILE__), "dummy_files/#{file_name}.rb"
  )
end
