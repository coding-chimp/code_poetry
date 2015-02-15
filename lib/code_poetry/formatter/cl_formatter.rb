module CodePoetry
  module Formatter
    class CLFormatter
      def format(stats)
        smelly_stats = stats.reject { |stat| stat.smells.empty? }

        smelly_stats.each { |stat| print_smells_for(stat) }
      end

      private

      def print_smells_for(stat)
        # TODO: Print out duplication smells
        smells = stat.smells.reject { |smell| smell.type == "duplication" }
        return if smells.empty?

        puts stat.name

        smells.each do |smell|
          print_smell(stat, smell)
        end

        puts
      end

      def print_smell(stat, smell)
        send("print_#{smell.type}", stat, smell)
      end

      def print_duplication(stat, smell)
      end

      def print_complex_method(_, smell)
        method = smell.object
        complexity = "(complexity = #{method.complexity})"

        puts "  Complex Method: #{method.pretty_name} #{complexity}"
      end

      def print_complex_class(stat, _)
        puts "  Complext Class (complexity = #{stat.complexity})"
      end

      def print_complex_class_definition(stat, _)
        complexity = "(complexity = #{stat.definition_complexity})"

        puts "  Complex Class Definition #{complexity}"
      end
    end
  end
end
