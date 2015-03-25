module CodePoetry
  module Formatter
    class CLFormatter
      def format(stats)
        smelly_stats = stats.reject { |stat| stat.smells.empty? }

        smelly_stats.each { |stat| print_smells_for(stat) }
      end

      private

      def print_smells_for(stat)
        smells = stat.smells
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
        duplication = smell.object

        puts <<-MESSAGE.gsub(/^ {8}/, '').gsub(/\n  /, ' ')
          #{duplication.severity} Code found in #{duplication.node} nodes
          (mass  = #{duplication.mass})
        MESSAGE

        duplication.methods.each do |method|
          puts "    #{method.pretty_location}"
        end
      end

      def print_complex_method(_, smell)
        method = smell.object

        puts <<-MESSAGE.gsub(/^ {8}/, '').gsub(/\n  /, ' ')
          Complex Method #{method.pretty_name} #{method.complexity}
          (complexity = #{method.complexity})
        MESSAGE
      end

      def print_complex_class(stat, _)
        puts "  Complex Class (complexity = #{stat.complexity})"
      end

      def print_complex_class_definition(stat, _)
        puts <<-MESSAGE.gsub(/^ {8}/, '')
          Complex Class Definition (complexity = #{stat.definition_complexity})
        MESSAGE
      end
    end
  end
end
