require 'code_poetry/calculator'
require 'code_poetry/stat'
require 'code_poetry/formatter'
require 'code_poetry-html'

module CodePoetry
  class CLI
    DIRECOTRIES = %w[app lib]
    EXTENSIONS = %w[rb rake]

    def self.excecute(directories = DIRECOTRIES)
      files = Array(expand_directories_to_files(*directories)).compact
      calculator = Calculator.new(files)
      stats = calculator.calculate

      formatter = CodePoetry::Formatter::HTMLFormatter.new
      formatter.format(stats)
    end

  private

    def self.expand_directories_to_files(*directories)
      directories.flatten.map { |element|
        if File.directory?(element)
          Dir[expanded_diroctory_path(element)]
        else
          element
        end
      }.flatten.sort
    end

    def self.expanded_diroctory_path(directory)
      File.join(directory, "{#{DIRECOTRIES.join(',')}}**", '**', "*.{#{EXTENSIONS.join(',')}}")
    end
  end
end
