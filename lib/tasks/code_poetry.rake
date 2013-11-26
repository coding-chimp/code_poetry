desc "Generate code metrics"
task :metrics do
  require 'code_poetry/cli'
  CodePoetry::CLI.excecute
end
