require 'rake'
require 'metrics/stat'
require 'churn/churn_calculator'
require 'flog_cli'
require 'hirb'

module Metrics
  class Run
    def initialize
      @files  = Array(FileList['app/**/*.rb']).compact
      @stats  = []
      @churns = {}
    end

    def run
      calculate_stats
      display_results
    end

    def calculate_stats
      puts "Calculating"

      measure_churns

      @files.each do |file|
        stat = Stat.new(file)

        stat.set_lines
        stat.set_churns(@churns[file])
        stat.set_flog

        @stats << stat
      end
    end

    def display_results
      results = @stats.sort_by!(&:name).map(&:to_h)
      fields  = [:name, :lines, :loc, :churns, :complexity, :methods, :complexity_per_method]

      puts Hirb::Helpers::AutoTable.render(results, fields: fields)
    end

  private

    def measure_churns
      churns = Churn::ChurnCalculator.new(history: false).report(false)

      churns[:churn][:changes].each do |churn|
        @churns[churn[:file_path]] = churn[:times_changed]
      end
    end

  end
end
