require 'code_poetry/calculator'
require 'code_poetry/stat'
require 'code_poetry/formatter'
require 'code_poetry-html'

module CodePoetry
  class CLI
    DIRECOTRIES = 'app,lib'

    def self.excecute(path)
      files = find_files(path)

      calculator = Calculator.new(path, files)
      stats = calculator.calculate

      formatter = CodePoetry::Formatter::HTMLFormatter.new
      formatter.format(stats)
    end

    private

    def self.find_files(path)
      paths = expand_path_to_files(path)
      Array(paths).compact.sort
    end

    def self.expand_path_to_files(path)
      if File.file?(path)
        path
      elsif path.nil?
        Dir[File.join(".", "{#{DIRECOTRIES}**}", "**", "*.rb")]
      else
        Dir[File.join(path, '**', "*.rb")]
      end
    end
  end
end
