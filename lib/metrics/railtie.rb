require 'rails'

module Metrics
  class Railtie < Rails::Railtie
    railtie_name :metrics

    rake_tasks do
      load "tasks/metrics.rake"
    end
  end
end
