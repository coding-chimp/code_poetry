require 'spec_helper'
require_relative '../lib/code_poetry/method'

describe CodePoetry::Method do
  let(:method) { CodePoetry::Method.new(:def, "smelly?", 8, 10) }

  describe ".smell?" do
    it "returns true if the complexity is greater 25" do
      method.complexity = 26
      expect(method.smelly?).to be_true
    end

    it "returns false if the complexity is less or equal 25" do
      method.complexity = 25
      expect(method.smelly?).to be_false
    end
  end

  describe ".pretty_name" do
    it "prepends a '.' to the name if the method is an instance method" do
      expect(method.pretty_name).to eq(".smelly?")
    end

    it "prepends a '#' to the name if the method is an class method" do
      method.node = :defs
      expect(method.pretty_name).to eq("#smelly?")
    end
  end
end
