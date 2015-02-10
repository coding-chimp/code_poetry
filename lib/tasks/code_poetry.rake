desc 'Generate code metrics'
task :metrics, :path do |t, args|
  require 'code_poetry/cli'

  CodePoetry::CLI.excecute(args.path)
end
