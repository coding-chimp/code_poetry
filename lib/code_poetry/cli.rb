require 'code_poetry/calculator'
require 'code_poetry/stat'
require 'code_poetry/formatter'
require 'code_poetry-html'

module CodePoetry
  class CLI
    DIRECOTRIES = 'app,lib'
    EXTENSIONS = 'rb,rake'

    def self.excecute(path)
      files = Array(expand_directories_to_files(path).sort).compact
      calculator = Calculator.new(path, files)
      stats = calculator.calculate

      formatter = CodePoetry::Formatter::HTMLFormatter.new
      formatter.format(stats)
    end

  private

    def self.expand_directories_to_files(path)
      if path
        Dir[File.join(path, "{#{DIRECOTRIES}}**", '**', "*.{#{EXTENSIONS}}")]
      else
        FileList[File.join("{#{DIRECOTRIES}}**", '**', "*.{#{EXTENSIONS}}")]
      end
    end
  end
end
