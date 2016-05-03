Gem::Specification.new do |spec|
  spec.name          = 'lita-alertlogic'
  spec.version       = '0.0.1'
  spec.authors       = ['Justin Early']
  spec.email         = ['jearly@alertlogic.com']
  spec.description   = 'A Lita handler for viewing alertlogic resources.'
  spec.summary       = 'A Lita handler for viewing alertlogic resources.'
  spec.homepage      = 'https://github.com/alertlogic/lita-alertlogic'
  spec.license       = 'MIT'
  spec.metadata      = { 'lita_plugin_type' => 'handler' }

  spec.files         = `git ls-files`.split($RS)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'lita', '>= 4.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pretty_table'
  spec.add_development_dependency 'uuid'
  spec.add_development_dependency 'rspec', '>= 3.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'coveralls'
end
