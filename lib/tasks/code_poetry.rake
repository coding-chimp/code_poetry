desc "Generate code metrics"
task :metrics, :path do |t, args|
  require 'code_poetry/cli'

  path = ARGV.last == 'metrics' ? '.' : ARGV.last

  CodePoetry::CLI.excecute(path)
end
