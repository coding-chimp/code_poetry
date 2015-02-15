desc 'Generate code metrics'
task :metrics, :path do |t, args|
  require 'code_poetry-html'
  require 'code_poetry/cli'

  formatter = CodePoetry::Formatter::HTMLFormatter.new

  CodePoetry::CLI.execute(args.path, formatter)
end
