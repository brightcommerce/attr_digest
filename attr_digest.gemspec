require './lib/attr_digest/version'

Gem::Specification.new do |spec|
  spec.name                  = "attr_digest"
  spec.version               = AttrDigest::VERSION::STRING
  spec.summary               = AttrDigest::VERSION::SUMMARY
  spec.description           = AttrDigest::VERSION::DESCRIPTION
  spec.platform              = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.2'
                             
  spec.authors               = ["Jurgen Jocubeit"]
  spec.email                 = ["support@brightcommerce.com"]
  spec.homepage              = "https://github.com/brightcommerce/attr_digest"
  spec.license               = 'MIT'
  spec.metadata              = { 'copyright' => 'Copyright 2016 Brightcommerce, Inc.' }
  
  spec.require_paths         = ["lib"]
  spec.files                 = Dir.glob("{lib,spec}/**/*") + %w(README.md CHANGELOG.md MIT-LICENSE)

  spec.add_runtime_dependency("activesupport")
  spec.add_runtime_dependency("activerecord")
  spec.add_runtime_dependency("argon2", "~> 0.1.4")

  spec.add_development_dependency("rake")
  spec.add_development_dependency("rspec")
  spec.add_development_dependency("sqlite3")
  spec.add_development_dependency("factory_girl")
  spec.add_development_dependency("simplecov")
end