# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'code_poetry/version'

Gem::Specification.new do |spec|
  spec.name          = 'code_poetry'
  spec.version       = CodePoetry::VERSION
  spec.authors       = ['Bastian Bartmann']
  spec.email         = ['babartmann@gmail.com']
  spec.description   = %q{Analyzes the code of your Rails app and generates a straightforward HTML report.}
  spec.summary       = %q{The poor men's Code Climate}
  spec.homepage      = 'https://github.com/coding-chimp/code_poetry'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'

  spec.add_runtime_dependency 'code_poetry-html', ['~> 0.2']
  spec.add_runtime_dependency 'flog',             ['~> 4.2']
  spec.add_runtime_dependency 'flay',             ['~> 2.4']
end
