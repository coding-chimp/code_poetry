require_relative 'test_helper'
require_relative '../lib/code_poetry/stat'

describe CodePoetry::Stat do
  before(:all) { @stat = CodePoetry::Stat.new(test_file(2), '') }
  after(:each) { @stat.smells = [] }

  describe '#initialize' do
    it 'sets the correct stat name' do
      stat = CodePoetry::Stat.new(test_file(1), '')

      @stat.name.must_equal 'Foo'
      stat.name.must_equal 'Foo'
      stat
    end

    it 'counts the correct number of lines and lines of code' do
      @stat.lines.count.must_equal 11
      @stat.lines_of_code.must_equal 8
    end

    it 'sets the methods correctly' do
      @stat.methods.count.must_equal 2

      method = @stat.get_method('bar?')
      method.node.must_equal :defs
      method.first_line.must_equal 3
      method.last_line.must_equal 5

      method = @stat.get_method('fooz?')
      method.node.must_equal :def
      method.first_line.must_equal 7
      method.last_line.must_equal 9
    end
  end

  describe '#set_churns' do
    it 'sets the churns' do
      @stat.set_churns(10)

      @stat.churns.must_equal 10
    end

    it 'leaves the churns alone, if the param is nil' do
      before = @stat.churns

      @stat.set_churns(nil)

      @stat.churns.must_equal before
    end
  end

  describe '#get_method' do
    it 'returns the method with the specified name' do
      @stat.get_method('bar?').first_line.must_equal 3
      @stat.get_method('fooz?').first_line.must_equal 7
    end

    it 'returns nil if there is no method with the specified name' do
      @stat.get_method('bar').must_equal nil
    end
  end

  describe '#set_method_complexity' do
    it 'sets the complexity of the method with the specified name' do
      @stat.set_method_complexity('bar?', 200)

      @stat.get_method('bar?').complexity.must_equal 200
    end

    it 'adds the complexity to the definition_complexity if there is no method with the specified name' do
      @stat.definition_complexity = 25
      @stat.set_method_complexity('baz', 120)

      @stat.definition_complexity.must_equal 145
    end
  end

  describe '#get_method_at_line' do
    it 'return the method at the specified line' do
      @stat.get_method_at_line(3).name.must_equal 'bar?'
    end

    it 'returns nil if there is no mehtod at the specified line' do
      @stat.get_method_at_line(20).must_equal nil
    end
  end

  describe '#set_smells' do
    it 'creates no complex_class smell if the overall complexity is less 151' do
      @stat.complexity = 150
      @stat.set_smells

      @stat.smells.detect { |smell| smell.type == 'complex_class' }.must_be_nil
    end

    it 'creates a complex_class smell if the overall complexity is greater 150' do
      @stat.complexity = 151
      @stat.set_smells

      @stat.smells.detect { |smell| smell.type == 'complex_class' }.wont_be_nil
    end

    it 'creates no complex_class_definition smell if the definition complexity is less 41' do
      @stat.definition_complexity = 40
      @stat.set_smells

      @stat.smells.detect { |smell| smell.type == 'complex_class_definition' }.must_be_nil
    end

    it 'creates a complex_class_definition smell if the definition complexity is greater 40' do
      @stat.definition_complexity = 41
      @stat.set_smells

      @stat.smells.detect { |smell| smell.type == 'complex_class_definition' }.wont_be_nil
    end

    it 'creates no complex_method smell if no methods complexity is greater 25' do
      @stat.set_method_complexity('bar?', 2)
      @stat.set_smells

      @stat.smells.detect { |smell| smell.type == 'complex_method' }.must_be_nil
    end

    it 'creates a complex_method smell if a methods complexity is greater 25' do
      @stat.set_method_complexity('bar?', 26)
      @stat.set_smells

      @stat.smells.detect { |smell| smell.type == 'complex_method' }.wont_be_nil
    end

    it 'creates no duplication smell if there is no duplication' do
      @stat.set_smells

      @stat.smells.detect { |smell| smell.type == 'duplication' }.must_be_nil
    end

    it 'creates a duplication smell if there is duplication' do
      @stat.duplications = [stub]
      @stat.set_smells

      @stat.smells.detect { |smell| smell.type == 'duplication' }.wont_be_nil
    end
  end

  describe '#duplication' do
    it 'adds up the masses of the duplications' do
      @stat.duplications = [
        stub(mass: 10, methods: [stub]),
        stub(mass: 5, methods: [stub])
      ]

      @stat.duplication.must_equal 15
    end
  end

  describe '#round_definition_complexity' do
    it 'should rount the definition complexity' do
      @stat.definition_complexity = 2.15

      @stat.round_definition_complexity

      @stat.definition_complexity.must_equal 2
    end
  end
end
