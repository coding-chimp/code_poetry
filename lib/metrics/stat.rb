module Metrics
  class Stat
    attr_accessor :file, :name, :lines, :loc, :churns, :complexity, :details, :complexity_per_method

    def initialize(file)
      @lines, @loc, @churns, @complexity, @complexity_per_method = 0, 0, 0, 0, 0
      @file    = file
      @details = {}
      @name    = parse_name
    end

    # Copied from code_metrics and modified so as not to introduce a dependency.
    # https://github.com/bf4/code_metrics/blob/master/lib/code_metrics/line_statistics.rb#L12
    def set_lines
      File.open(file, 'r') do |f|
        while line = f.gets
          @lines += 1
          next if line =~ /^\s*$/
          next if line =~ /^\s*#/
          @loc += 1
        end
      end
    end

    def set_churns(churns)
      @churns = churns if churns
    end

    def set_flog
      flogger = FlogCLI.new(all: true)
      flogger.flog(file)
      flogger.calculate

      unless flogger.scores.empty?
        klass                  = flogger.scores.first[0]
        @complexity            = flogger.total_score.round(2)
        @complexity_per_method = flogger.average.round(2)

        flogger.method_scores[klass].each do |name, score|
          details[name] = {complexity: score, location: flogger.method_locations[name]}
        end
      end
    end

    def methods
      details.reject{|k,v| k.include?("#none")}.size
    end

    def to_h
      { file: file, name: name, lines: lines, loc: loc, churns: churns, complexity: complexity,
        methods: methods, complexity_per_method: complexity_per_method }
    end

  private

    def parse_name
      content = File.open(@file, "r").read

      if match = /^\s*class\s+(\S+)/.match(content) || /^\s*module\s+(\S+)/.match(content)
        match[1]
      else
        "undefined"
      end
    end

  end
end
