require "code_poetry/version"
require "fileutils"

module CodePoetry
  if defined?(Rails)
    require "code_poetry/railtie"
  end

  class << self
    def root
      @root ||= File.expand_path(Dir.getwd)
    end

    def coverage_path
      coverage_path = File.expand_path("metrics", root)
      FileUtils.mkdir_p(coverage_path)
      coverage_path
    end

    def project_name
      @project_name ||= File.basename(root)
        .split(/[-_]/)
        .map(&:capitalize)
        .join(" ")
    end
  end
end
