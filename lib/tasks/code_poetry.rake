desc "Generate code metrics"
task :metrics, :path do |t, args|
  require 'code_poetry/cli'

  path = ARGV.last unless ARGV.last == 'metrics'

  CodePoetry::CLI.excecute(path)
end
