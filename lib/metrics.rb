require "metrics/version"

module Metrics
  if defined?(Rails)
    require 'metrics/railtie'
  else
    load "tasks/metrics.rake"
  end
end
