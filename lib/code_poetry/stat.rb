require 'code_poetry/method'
require 'code_poetry/warning_scanner'
require 'code_poetry/smell'

module CodePoetry
  class Stat
    attr_accessor :file, :name, :lines, :lines_of_code, :churns, :complexity, :methods, :smells
    attr_accessor :complexity_per_method, :definition_complexity

    def initialize(file)
      @lines_of_code, @churns, @complexity, @complexity_per_method, @definition_complexity = 0, 0, 0, 0, 0
      @file    = file
      @lines   = {}
      @methods = []
      @smells  = []

      parse_file
    end

    def set_churns(churns)
      @churns = churns if churns
    end

    def get_method(name)
      method = @methods.find{|method| method.name == name}
    end

    def set_method_complexity(name, score)
      if method = get_method(name)
        method.complexity = score.round(0)
      else
        @definition_complexity += score
      end
    end

    def get_method_at_line(line)
      method = @methods.find{|method| method.first_line <= line && method.last_line >= line}
    end

    def set_smells
      set_class_smells
      set_method_smells
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
            warning = @indentation_warnings['def'].find{|first, last| first == first_line}
            last_line = warning[1]
          else
            last_line = find_last_line(name, first_line)
          end

          @methods << Method.new(element.first, name, first_line, last_line)
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

    def find_last_line(token_name, line)
      token_indentation = @lines[line].index('def')

      last_line = @lines.values[line..-1].index { |l| l =~ %r(\A\s{#{token_indentation}}end\s*\z) }
      last_line ? last_line + line + 1 : nil
    end

    def indentation_warnings
      warning_scanner = WarningScanner.new
      warning_scanner.scan(@content)
    end

    def set_class_smells
      @smells << Smell.new("ComplexClass")           if @complexity > 150
      @smells << Smell.new("ComplexClassDefinition") if @definition_complexity > 40
    end

    def set_method_smells
      smelly_methods = @methods.select{|method| method.smelly?}
      @smells.concat smelly_methods.map{|method| Smell.new("ComplexMethod", method)}
    end
  end
end
