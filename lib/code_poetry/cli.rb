require 'rake'
require 'code_poetry/calculator'
require 'code_poetry/warning_scanner'
require 'code_poetry/stat'
require 'code_poetry-html'
require 'churn/churn_calculator'
require 'flog_cli'
require 'hirb'

require 'ripper'

module CodePoetry
  class CLI
    def self.excecute
      files = Array(FileList['app/**/*.rb']).compact
      calculator = Calculator.new(files)
      stats = calculator.calculate

      formatter = CodePoetry::Formatter::HTMLFormatter.new
      formatter.format(stats)
    end
  end
end
