# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'email_sanitizer/version'
require 'English'

Gem::Specification.new do |spec|
  spec.name          = 'email_sanitizer'
  spec.version       = EmailSanitizer::VERSION
  spec.authors       = ['Holman Gao']
  spec.email         = ['holman@golmansax.com']
  spec.summary       = 'Library to fix invalid emails'
  spec.description   = ''
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = Dir['{lib}/**/*', 'LICENSE', 'README.md']
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = Dir['spec/**/*']
  spec.require_paths = ['lib']
end
