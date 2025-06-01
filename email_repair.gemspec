lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'email_repair/version'
require 'English'

Gem::Specification.new do |spec|
  spec.name          = 'email_repair'
  spec.version       = EmailRepair::VERSION
  spec.authors       = ['Holman Gao', 'JT Bowler']
  spec.email         = ['holman@golmansax.com', 'jbowler2400@gmail.com']
  spec.summary       = 'Library to fix invalid emails'
  spec.homepage      = 'https://github.com/ChalkSchools/email-repair'
  spec.license       = 'MIT'

  spec.files         = Dir['{lib}/**/*', 'LICENSE', 'README.md']
  spec.executables   = spec.files.grep(%r{^bin\/}) { |f| File.basename(f) }
  spec.test_files    = Dir['spec/**/*']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'coveralls', '~> 0.8.23'
  spec.add_development_dependency 'rake', '~> 13.0.6'
  spec.add_development_dependency 'rspec', '~> 3.12.0'
  spec.add_development_dependency 'rubocop', '~> 1.75.8'
end
