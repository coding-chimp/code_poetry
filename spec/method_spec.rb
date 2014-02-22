require 'spec_helper'
require_relative '../lib/code_poetry/method'

describe CodePoetry::Method do
  let(:method) { CodePoetry::Method.new(:def, 'smelly?', 8, 10, 'path') }

  describe '#smelly?' do
    it "returns true if the complexity is greater 25" do
      method.complexity = 26
      expect(method.smelly?).to be_true
    end

    it "returns false if the complexity is less or equal 25" do
      method.complexity = 25
      expect(method.smelly?).to be_false
    end
  end

  describe '#duplicated?' do
    it "returns true if the duplication count is greater 0" do
      method.duplication_count = 1
      expect(method.duplicated?).to be_true
    end

    it "returns false if the duplication count is equal 0" do
      method.duplication_count = 0
      expect(method.duplicated?).to be_false
    end
  end

  describe '#pretty_name' do
    it "prepends a '.' to the name if the method is an instance method" do
      expect(method.pretty_name).to eq(".smelly?")
    end

    it "prepends a '#' to the name if the method is an class method" do
      method.node = :defs
      expect(method.pretty_name).to eq("#smelly?")
    end
  end

  describe '#pretty_location' do
    it 'something' do
      expect(method.pretty_location).to eq('path:8..10')
    end
  end

  describe '#increase_duplication_count' do
    it 'increases the duplication count by 1' do
      expect{
        method.increase_duplication_count
      }.to change{ method.duplication_count }.by(1)
    end
  end
end
