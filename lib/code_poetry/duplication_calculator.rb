require 'flay'

module CodePoetry
  class DuplicationCalculator
    def initialize(files, stats)
      @files = files
      @stats = stats
      @flay  = Flay.new
    end

    def measure
      flay_files

      sorted_flays.each do |hash, mass|
        evaluate_flay(hash, mass)
      end
    end

  private

    def flay_files
      @flay.process(*@files)
      @flay.analyze
    end

    def sorted_flays
      @flay.masses.sort_by do |h, m|
        [
          -m,
          @flay.hashes[h].first.file,
          @flay.hashes[h].first.line,
          @flay.hashes[h].first.first.to_s
        ]
      end
    end

    def evaluate_flay(hash, mass)
      nodes = fetch_nodes(hash)

      stats, methods = fetch_stats_and_methods(nodes)

      stats.each do |stat|
        unless methods.empty?
          stat.duplications << Duplication.new(severity(hash), note_type(nodes), mass, methods)
        end
      end
    end

    def fetch_nodes(hash)
      @flay.hashes[hash].sort_by { |node| [node.file, node.line] }
    end

    def fetch_stats_and_methods(nodes)
      nodes.inject([[], []]) do |result, node|
        stat = find_stat(node.file)
        result[0] << stat

        method = stat.get_method_at_line(node.line)

        unless method.nil?
          method.increase_duplication_count
          result[1] << method
        end

        result
      end
    end

    def find_stat(filename)
      @stats.detect { |stat| stat.absolute_path == filename }
    end

    def severity(hash)
      @flay.identical[hash] ? 'Identical' : 'Similar'
    end

    def note_type(nodes)
      nodes.first.first
    end
  end
end
