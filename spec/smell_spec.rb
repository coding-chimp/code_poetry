require 'spec_helper'
require_relative '../lib/code_poetry/smell'

describe CodePoetry::Smell do
  let(:smell) { CodePoetry::Smell.new("ComplexClass") }

  describe ".complex_class?" do
    it "returns true if the smells type is 'ComplexClass'" do
      expect(smell.complex_class?).to be_true
    end

    it "returns false if the smell type isn't 'ComplexClass'" do
      smell.type = "ComplexClassDefinition"
      expect(smell.complex_class?).to be_false
    end
  end

  describe ".complex_class_definition?" do
    it "returns true if the smells type is 'ComplexClassDefinition'" do
      smell.type = "ComplexClassDefinition"
      expect(smell.complex_class_definition?).to be_true
    end

    it "returns false if the smell type isn't 'ComplexClassDefinition'" do
      expect(smell.complex_class_definition?).to be_false
    end
  end

  describe ".complex_method?" do
    it "returns true if the smells type is 'ComplexMethod'" do
      smell.type = "ComplexMethod"
      expect(smell.complex_method?).to be_true
    end

    it "returns false if the smell type isn't 'ComplexMethod'" do
      expect(smell.complex_method?).to be_false
    end
  end
end
