require_relative 'test_helper'
require_relative '../lib/code_poetry/method'

describe CodePoetry::Method do
  let(:meth) { CodePoetry::Method.new(:def, 'smelly?', 8, 10, 'path') }

  describe '#smelly?' do
    it 'returns true if the complexity is greater 25' do
      meth.complexity = 26

      meth.smelly?.must_equal true
    end

    it 'returns false if the complexity is less or equal 25' do
      meth.complexity = 25

      meth.smelly?.must_equal false
    end
  end

  describe '#duplicated?' do
    it 'returns true if the duplication count is greater 0' do
      meth.duplication_count = 1

      meth.duplicated?.must_equal true
    end

    it 'returns false if the duplication count is equal 0' do
      meth.duplication_count = 0

      meth.duplicated?.must_equal false
    end
  end

  describe '#pretty_name' do
    it 'prepends a "." to the name if the method is an instance method' do
      meth.node = :def

      meth.pretty_name.must_equal '.smelly?'
    end

    it 'prepends a "#" to the name if the method is an class method' do
      meth.node = :defs

      meth.pretty_name.must_equal'#smelly?'
    end
  end

  describe '#pretty_location' do
    it 'returns the location and line number range' do
      meth.pretty_location.must_equal 'path:8..10'
    end
  end

  describe '#increase_duplication_count' do
    it 'increases the duplication count by 1' do
      before = meth.duplication_count

      meth.increase_duplication_count

      meth.duplication_count.must_equal before + 1
    end
  end
end
