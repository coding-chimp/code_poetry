require 'spec_helper'
require_relative '../lib/code_poetry/stat'

describe CodePoetry::Stat do
  before(:all) { @stat = CodePoetry::Stat.new(test_file(2)) }
  after(:each) { @stat.smells = [] }

  describe '#initialize' do
    it 'sets the correct stat name' do
      expect(@stat.name).to eq('Foo')
    end

    it 'counts the correct number of lines and lines of code' do
      expect(@stat.lines.count).to eq(11)
      expect(@stat.lines_of_code).to eq(8)
    end

    it 'sets the methods correctly' do
      expect(@stat.methods.count).to eq(2)

      method = @stat.get_method('bar?')
      expect(method.node).to eq(:defs)
      expect(method.first_line).to eq(3)
      expect(method.last_line).to eq(5)

      method = @stat.get_method('fooz?')
      expect(method.node).to eq(:def)
      expect(method.first_line).to eq(7)
      expect(method.last_line).to eq(9)
    end
  end

  describe '#set_churns' do
    it 'sets the churns' do
      @stat.set_churns(10)

      expect(@stat.churns).to eq(10)
    end

    it 'leaves the churns alone, if the param is nil' do
      expect { @stat.set_churns(nil) }.not_to change { @stat.churns }
    end
  end

  describe '#get_method' do
    it 'returns the method with the specified name' do
      expect(@stat.get_method('bar?').first_line).to eq(3)
      expect(@stat.get_method('fooz?').first_line).to eq(7)
    end

    it 'returns nil if there is no method with the specified name' do
      expect(@stat.get_method('bar')).to eq(nil)
    end
  end

  describe '#set_method_complexity' do
    it 'sets the complexity of the method with the specified name' do
      @stat.set_method_complexity('bar?', 200)

      expect(@stat.get_method('bar?').complexity).to eq(200)
    end

    it 'adds the complexity to the definition_complexity if there is no method with the specified name' do
      @stat.definition_complexity = 25
      @stat.set_method_complexity('baz', 120)

      expect(@stat.definition_complexity).to eq(145)
    end
  end

  describe '#get_method_at_line' do
    it 'return the method at the specified line' do
      expect(@stat.get_method_at_line(3).name).to eq('bar?')
    end

    it 'returns nil if there is no mehtod at the specified line' do
      expect(@stat.get_method_at_line(20)).to eq(nil)
    end
  end

  describe '#set_smells' do
    it 'creates no complex_class smell if the overall complexity is less 151' do
      @stat.complexity = 150
      @stat.set_smells

      expect(@stat.smells.detect { |smell| smell.type == 'complex_class' }).to be_nil
    end

    it 'creates a complex_class smell if the overall complexity is greater 150' do
      @stat.complexity = 151
      @stat.set_smells

      expect(@stat.smells.detect { |smell| smell.type == 'complex_class' }).to_not be_nil
    end

    it 'creates no complex_class_definition smell if the definition complexity is less 41' do
      @stat.definition_complexity = 40
      @stat.set_smells

      expect(@stat.smells.detect { |smell| smell.type == 'complex_class_definition' }).to be_nil
    end

    it 'creates a complex_class_definition smell if the definition complexity is greater 40' do
      @stat.definition_complexity = 41
      @stat.set_smells

      expect(@stat.smells.detect { |smell| smell.type == 'complex_class_definition' }).to_not be_nil
    end

    it 'creates no complex_method smell if no methods complexity is greater 25' do
      @stat.set_method_complexity('bar?', 2)
      @stat.set_smells

      expect(@stat.smells.detect { |smell| smell.type == 'complex_method' }).to be_nil
    end

    it 'creates a complex_method smell if a methods complexity is greater 25' do
      @stat.set_method_complexity('bar?', 26)
      @stat.set_smells

      expect(@stat.smells.detect { |smell| smell.type == 'complex_method' }).to_not be_nil
    end

    it 'creates no duplication smell if there is no duplication' do
      @stat.set_smells

      expect(@stat.smells.detect { |smell| smell.type == 'duplication' }).to be_nil
    end

    it 'creates a duplication smell if there is duplication' do
      @stat.duplications = [double]
      @stat.set_smells

      expect(@stat.smells.detect { |smell| smell.type == 'duplication' }).to_not be_nil
    end
  end

  describe '#duplication' do
    it 'adds up the masses of the duplications' do
      @stat.duplications = [double(mass: 10, methods: [double]), double(mass: 5, methods: [double])]

      expect(@stat.duplication).to eq(15)
    end
  end
end
