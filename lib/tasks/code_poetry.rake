desc 'Generate code metrics'
task :metrics, :path do |t, args|
  require 'code_poetry/cli'

  path = args.path || '.'

  CodePoetry::CLI.excecute(path)
end
