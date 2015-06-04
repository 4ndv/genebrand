# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'genebrand/version'

Gem::Specification.new do |spec|
  spec.name          = 'genebrand'
  spec.version       = Genebrand::VERSION
  spec.authors       = ['Andrey Viktorov']
  spec.email         = ['andv@outlook.com']

  spec.summary       = 'Genebrand is a small brands generator'
  spec.description   = 'CLI brand names generator'
  spec.homepage      = 'https://github.com/andreyviktorov/genebrand'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|seed)/}) } - %w(.gitignore lib/data/pos.txt)
  spec.bindir        = 'exe'
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.executables   = ['genebrand']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'colorator', '~> 0.1'
  spec.add_runtime_dependency 'mercenary', '~> 0.3'
  spec.add_runtime_dependency 'highline', '~> 1.7'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
end
