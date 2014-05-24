require 'open3'

module CodePoetry
  class WarningScanner
    INDENTATION_WARNING_REGEXP = /at 'end' with '(def|class|module)' at (\d+)\z/

    def scan(source)
      if defined? Bundler
        Bundler.with_clean_env do
          status, @warnings, process = validate(source)
        end
      else
        status, @warnings, process = validate(source)
      end

      parse_warnings
    end

  private

    def validate(source)
      Open3.capture3('ruby -wc', stdin_data: source)
    end

    def parse_warnings
      @warnings.split("\n").inject({}) do |warnings, warning|
        token, line, end_line = extract_indentation_mismatch(warning)
        if token == 'def'
          warnings[token] ||= []
          warnings[token] << [line.to_i, end_line.to_i]
        end
        warnings
      end
    end

    def extract_indentation_mismatch(warning_line)
      _, end_line_num, warning_type, warning_body = warning_line.split(':').map(&:strip)
      return nil unless warning_type == 'warning'
      return nil unless warning_body =~ /at 'end' with '(def|class|module)' at (\d+)\z/

      warning_body.match(INDENTATION_WARNING_REGEXP)[1..2] << end_line_num
    end

  end
end
