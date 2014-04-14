# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'retrieval_lite/version'

Gem::Specification.new do |spec|
  spec.name          = "retrieval_lite"
  spec.version       = RetrievalLite::VERSION
  spec.authors       = ["Irvin Zhan"]
  spec.email         = ["izhan@princeton.edu"]
  spec.description   = %q{Lightweight gem for document retrieval using tf-idf based algorithms for Ruby on Rails applications}
  spec.summary       = %q{Please see associated GitHub page for usage.}
  spec.homepage      = "https://github.com/izhan/retrieval_lite"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
