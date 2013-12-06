# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cinch/plugins/links-titles/version'

Gem::Specification.new do |spec|
  spec.name          = "cinch-links-titles"
  spec.version       = Cinch::Plugins::LinksTitles::VERSION
  spec.authors       = ['Brian Haberer']
  spec.email         = ['bhaberer@gmail.com']
  spec.description   = %q{Cinch Plugin to print link titles to the channel}
  spec.summary       = %q{Link Titles}
  spec.homepage      = 'https://github.com/bhaberer/cinch-links-titles'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'cinch-test'

  spec.add_dependency 'cinch',           '~> 2.0.5'
  spec.add_dependency 'cinch-cooldown',  '~> 1.0.0'
  spec.add_dependency 'cinch-storage',   '~> 1.0.1'
  spec.add_dependency 'cinch-toolbox',   '~> 1.0.3'
  spec.add_dependency 'time-lord',       '~> 1.0.1'
end
