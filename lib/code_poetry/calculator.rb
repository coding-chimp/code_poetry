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

      @files.each do |file|
        stat = Stat.new(file)

        stat.set_churns(@churns[file])
        measure_flog(stat)

        @stats << stat
      end

      @stats
    end

  private

    def measure_churns
      churns = Churn::ChurnCalculator.new(history: false).report(false)

      churns[:churn][:changes].each do |churn|
        @churns[churn[:file_path]] = churn[:times_changed]
      end
    end

    def measure_flog(stat)
      flogger = FlogCLI.new(all: true)
      flogger.flog(stat.file)
      flogger.calculate

      outside_methods = 0

      unless flogger.scores.empty?
        klass                      = flogger.scores.first[0]
        stat.complexity            = flogger.total_score.round(2)
        stat.complexity_per_method = flogger.average.round(2)

        flogger.method_scores[klass].each do |name, score|
          next if score.nil?

          name = (name.match(/#(.+)/) || name.match(/::(.+)/))[1]
          method = stat.get_method(name)

          if method
            method[:complexity] = score.round(2)
          else
            outside_methods += score
          end
        end
      end

      stat.set_outside_of_methods_complexity(outside_methods.round(2))
    end
  end
end
