lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "miriamtech/gocd/version"

Gem::Specification.new do |spec|
  spec.name          = "miriamtech-gocd"
  spec.version       = MiriamTech::GoCD::VERSION
  spec.authors       = ["Ken Treis"]
  spec.email         = ["ken@miriamtech.com"]

  spec.summary       = %q{Utilities for building apps in Docker containers with GoCD}
  spec.homepage      = "https://www.miriamtech.com"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/miriamtech/gocd"
  spec.metadata["changelog_uri"] = "https://github.com/miriamtech/gocd/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rake", ">= 10.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency 'rspec-expectations'
  spec.add_development_dependency 'rspec-mocks'
end
