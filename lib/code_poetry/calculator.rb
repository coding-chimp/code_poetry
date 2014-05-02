require 'churn/calculator'
require 'code_poetry/complexity_calculator'
require 'flay'

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
      measure_flay

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

    def measure_flay
      flay = Flay.new
      flay.process(*@files)
      flay.analyze

      flays = sort_flays(flay)

      flays.each do |hash, mass|
        nodes = flay.hashes[hash]
        same = flay.identical[hash]
        node = nodes.first

        match, bonus = same ? ["Identical", "*#{nodes.size}"] : ["Similar",   ""]

        dups = []

        nodes.sort_by { |node| [node.file, node.line] }.each do |node|
          stat   = find_stat(node.file)
          method = stat.get_method_at_line(node.line)

          method.increase_duplication_count

          dups << [stat, method]
        end

        methods = dups.map{ |dup| dup[1] }

        dups.each do |stat, method|
          stat.duplications << Duplication.new(match, node.first, mass, methods)
        end
      end
    end

    def sort_flays(flay)
      flay.masses.sort_by do |h, m|
        [
          -m,
          flay.hashes[h].first.file,
          flay.hashes[h].first.line,
          flay.hashes[h].first.first.to_s
        ]
      end
    end

    def find_stat(filename)
      @stats.detect{ |stat| stat.file == filename }
    end
  end
end
