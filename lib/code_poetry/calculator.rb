require 'code_poetry/complexity_calculator'
require 'code_poetry/churn_calculator'
require 'code_poetry/duplication_calculator'

module CodePoetry
  class Calculator
    def initialize(path, files)
      @path   = path
      @files  = files
      @stats  = []
    end

    def calculate
      puts 'Calculating'

      create_stats
      measure_duplication

      @stats.each do |stat|
        stat.set_smells
      end
    end

    private

    def create_stats
      @files.each do |file|
        stat = Stat.new(file)
        measure_complexity(stat)
        measure_churns(stat)
        @stats << stat
      end
    end

    def measure_complexity(stat)
      ComplexityCalculator.new(stat).measure
    end

    def measure_churns(stat)
      churn_calculator.calculate(stat)
    end

    def churn_calculator
      @churn_calculator ||= ChurnCalculator.new(@path)
    end

    def measure_duplication
      DuplicationCalculator.new(@files, @stats).measure
    end
  end
end
