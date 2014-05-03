require 'flog_cli'

module CodePoetry
  class ComplexityCalculator
    def initialize(stat)
      @stat    = stat
      @flogger = FlogCLI.new(all: true)
    end

    def measure
      flog_file

      unless @flogger.scores.empty?
        set_file_complexity
        set_methods_complexity
      end

      @stat.round_definition_complexity
    end

  private

    def flog_file
      @flogger.flog(@stat.file)
      @flogger.calculate
    end

    def set_file_complexity
      @stat.complexity            = @flogger.total_score.round(0)
      @stat.complexity_per_method = @flogger.average.round(0)
    end

    def set_methods_complexity
      klass = @flogger.scores.first[0]

      @flogger.method_scores[klass].each do |name, score|
        name = (name.match(/#(.+)/) || name.match(/::(.+)/))[1]
        @stat.set_method_complexity(name, score)
      end
    end
  end
end
