require 'code_poetry/method'
require 'code_poetry/warning_scanner'
require 'ripper'

module CodePoetry
  Duplication = Struct.new(:severity, :node, :mass, :methods)
  Smell = Struct.new(:type, :object)

  class Stat
    attr_reader :duplication, :file, :lines, :lines_of_code, :name, :methods
    attr_accessor :churns, :complexity, :complexity_per_method, :definition_complexity
    attr_accessor :duplications, :smells

    def initialize(file)
      @file = file
      @lines_of_code, @churns = 0, 0
      @complexity, @complexity_per_method, @definition_complexity = 0, 0, 0
      @methods, @smells, @duplications = [], [], []
      @lines = {}

      parse_file
    end

    def set_churns(churns)
      @churns = churns if churns
    end

    def get_method(name)
      @methods.detect{ |method| method.name == name }
    end

    def set_method_complexity(name, score)
      if method = get_method(name)
        method.complexity = score.round(0)
      else
        @definition_complexity += score
      end
    end

    def get_method_at_line(line)
      @methods.detect{ |method| method.first_line <= line && method.last_line >= line }
    end

    def set_smells
      set_class_smells
      set_method_smells
      set_duplication_smells
    end

    def duplication
      @duplications.map{ |duplication| duplication.mass / duplication.methods.count }.inject(0, :+)
    end

    def round_definition_complexity
      @definition_complexity = @definition_complexity.round(0)
    end

  private

    def parse_file
      @content = File.open(@file, "r").read
      @indentation_warnings = indentation_warnings

      set_name
      set_lines
      set_methods
    end

    def set_name
      @content = File.open(@file, "r").read

      if match = /^\s*class\s+(\S+)/.match(@content) || /^\s*module\s+(\S+)/.match(@content)
        @name = match[1]
      end
    end

    def set_lines
      @content.each_line.with_index(1) do |line, i|
        @lines[i] = line
        next if line =~ /^\s*$/
        next if line =~ /^\s*#/
        @lines_of_code += 1
      end
    end

    def set_methods
      sexp = Ripper.sexp(@content)
      scan_sexp(sexp)
    end

    def scan_sexp(sexp)
      sexp.each do |element|
        next unless element.kind_of?(Array)

        case element.first
        when :def, :defs
          name, first_line = find_method_params(element)

          if @indentation_warnings['def'] && @indentation_warnings['def'].any? { |first, last| first == first_line }
            warning = @indentation_warnings['def'].detect{ |first, last| first == first_line }
            last_line = warning[1]
          else
            last_line = find_last_line(name, first_line)
          end

          @methods << Method.new(element.first, name, first_line, last_line, @file)
        else
          scan_sexp(element)
        end
      end
    end

    def find_method_params(sexp)
      if sexp.first == :def
        sexp[1].flatten[1,2]
      else
        sexp[3].flatten[1,2]
      end
    end

    def indentation_warnings
      warning_scanner = WarningScanner.new
      warning_scanner.scan(@content)
    end

    def find_last_line(token_name, line)
      token_indentation = @lines[line].index('def')

      last_line = @lines.values[line..-1].index { |l| l =~ %r(\A\s{#{token_indentation}}end\s*\z) }
      last_line ? last_line + line + 1 : nil
    end

    def set_class_smells
      @smells << Smell.new("complex_class", nil)            if @complexity > 150
      @smells << Smell.new("complex_class_definition", nil) if @definition_complexity > 40
    end

    def set_method_smells
      smelly_methods = @methods.select{ |method| method.smelly? }
      @smells.concat smelly_methods.map{ |method| Smell.new("complex_method", method) }
    end

    def set_duplication_smells
      unique_duplications = []

      @duplications.each do |duplication|
        unless unique_duplications.any?{ |d| d.methods == duplication.methods }
          unique_duplications << duplication
        end
      end

      @smells.concat unique_duplications.map{ |duplication| Smell.new("duplication", duplication) }
    end
  end
end
