require 'churn/calculator'
require 'code_poetry/complexity_calculator'
require 'code_poetry/duplication_calculator'

module CodePoetry
  class Calculator
    def initialize(files)
      @files  = files
      @churns = {}
      @stats  = []
    end

    def calculate
      puts 'Calculating'

      measure_churns
      measure_complexity
      measure_duplication

      @stats.each do |stat|
        stat.set_churns(@churns[stat.file])
        stat.set_smells
      end
    end

  private

    def measure_churns
      churns = Churn::ChurnCalculator.new(history: false).report(false)

      churns[:churn][:changes].each do |churn|
        @churns[churn[:file_path]] = churn[:times_changed]
      end
    end

    def measure_complexity
      @files.each do |file|
        stat = Stat.new(file)
        ComplexityCalculator.new(stat).measure
        @stats << stat
      end
    end

    def measure_duplication
      DuplicationCalculator.new(@files, @stats).measure
    end
  end
end
