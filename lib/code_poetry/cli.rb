require 'code_poetry/calculator'
require 'code_poetry/stat'
require 'code_poetry/formatter'

module CodePoetry
  class CLI
    DIRECOTRIES = 'app,lib'

    def self.execute(path, formatter)
      files = find_files(path)

      puts files

      calculator = Calculator.new(path, files)
      stats = calculator.calculate

      if formatter
        formatter.format(stats)
      end
    end

    private

    def self.find_files(path)
      paths = expand_path_to_files(path)
      Array(paths).compact.sort
    end

    def self.expand_path_to_files(path)
      if path.nil?
        Dir[File.join(".", "{#{DIRECOTRIES}**}", "**", "*.rb")]
      elsif File.file?(path)
        path
      else
        Dir[File.join(path, '**', "*.rb")]
      end
    end
  end
end
