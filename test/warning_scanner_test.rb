require_relative 'test_helper'
require_relative '../lib/code_poetry/warning_scanner'

describe CodePoetry::WarningScanner do
  let(:scanner) { CodePoetry::WarningScanner.new }

  describe '#scan' do
    it 'returns an empty array if there are no warnings' do
      require 'bundler'
      source = File.open(test_file(1), 'r').read

      scanner.scan(source).size.must_equal 0
    end

    it 'returns an array with warnings for every indendation in the source' do
      source = File.open(test_file(2), 'r').read

      warnings = scanner.scan(source)

      warnings['def'].size.must_equal 2
      warnings['def'][0].must_equal [3, 5]
      warnings['def'][1].must_equal [7, 9]
    end
  end
end
