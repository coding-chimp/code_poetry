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
      measure_churns
      measure_duplication

      @stats.each do |stat|
        measure_complexity(stat)
        stat.set_churns(@churns[stat.relative_path])
        stat.set_smells
      end
    end

    private

    def create_stats
      @files.each do |file|
        stat = Stat.new(file, @path)

        unless stat.name.nil?
          @stats << stat
        end
      end
    end

    def measure_churns
      @churns = ChurnCalculator.new(@path).calculate
    end

    def measure_complexity(stat)
      ComplexityCalculator.new(stat).measure
    end

    def measure_duplication
      DuplicationCalculator.new(@files, @stats).measure
    end
  end
end
