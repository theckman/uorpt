# -*- coding: UTF-8 -*-
require 'English'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'uorpt/version'

Gem::Specification.new do |spec|
  spec.name        = 'UOrpt'
  spec.version     = UOrpt::VERSION
  spec.date        = Time.now.strftime('%Y-%m-%d')
  spec.summary     = 'UO rpt log parser'
  spec.description = 'Parses the UnitedOperations logs to files on disk'
  spec.authors     = ['Tim Heckman']
  spec.email       = 't@heckman.io'
  spec.homepage    = 'https://github.com/theckman/uorpt'
  spec.license     = 'MIT'
  spec.required_ruby_version = '>= 2.1.0'

  spec.test_files  = `git ls-files spec/*`.split
  spec.files       = `git ls-files`.split
  spec.executables = %w(uorptd)

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 10.2'
  spec.add_development_dependency 'rubocop', '~> 0.24', '>= 0.24.1'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'fuubar', '>= 2.0.0.rc1'
  spec.add_development_dependency 'coveralls', '~> 0.7'
  spec.add_development_dependency 'simplecov', '~> 0.8', '>= 0.8.2'

  spec.add_runtime_dependency 'rmuh', '~> 0.3'
  spec.add_runtime_dependency 'sentry-raven'
end
