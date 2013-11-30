require 'spec_helper'
require_relative '../lib/code_poetry/warning_scanner'

describe CodePoetry::WarningScanner do
  let(:scanner) { CodePoetry::WarningScanner.new }

  describe ".scan" do
    it "returns an array with warnings for every indendation in the source" do
      source = File.open(test_file(1), "r").read
      expect(scanner.scan(source).size).to eq(0)

      source = File.open(test_file(2), "r").read
      expect(scanner.scan(source)["def"].size).to eq(2)
      expect(scanner.scan(source)["def"][0]).to   eq([3, 5])
      expect(scanner.scan(source)["def"][1]).to   eq([7, 9])
    end
  end
end
