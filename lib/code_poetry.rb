require 'code_poetry/version'
require 'fileutils'

module CodePoetry
  if defined?(Rails)
    require 'code_poetry/railtie'
  else
    load 'tasks/code_poetry.rake'
  end

  class << self
    def root
      return @root if defined? @root
      @root = File.expand_path(Dir.getwd)
    end

    def coverage_path
      coverage_path = File.expand_path('metrics', root)
      FileUtils.mkdir_p coverage_path
      coverage_path
    end

    def project_name
      return @project_name if defined? @project_name
      @project_name = File.basename(root.split('/').last).capitalize.gsub('_', ' ')
    end

    def project_name
      File.basename(root.split('/').last).capitalize.gsub('_', ' ')
    end
  end
end
