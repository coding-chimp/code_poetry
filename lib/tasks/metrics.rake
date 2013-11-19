namespace :metrics do
  desc "All metrics together."
  task :run do
    require 'metrics/run'
    Metrics::Run.new.run
  end
end
