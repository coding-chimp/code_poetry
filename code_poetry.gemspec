# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'code_poetry/version'

Gem::Specification.new do |spec|
  spec.name          = "code_poetry"
  spec.version       = CodePoetry::VERSION
  spec.authors       = ["coding-chimp"]
  spec.email         = ["babartmann@gmail.com"]
  spec.description   = %q{Rails Metrics}
  spec.summary       = %q{Rails Metrics}
  spec.homepage      = "http://code-chimp.org"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency 'code_metrics', ['~> 0.1']
  spec.add_runtime_dependency 'churn',        ['~> 0.0']
  spec.add_runtime_dependency 'flog',         ['~> 4.2']
end
