lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dry-service/version"

ERR_RG_2_REQUIRED = "RubyGems 2.0 or newer is required to protect against public gem pushes.".freeze

Gem::Specification.new do |spec|
  # RubyGems < 2.0 does not allow to specify metadata. We do not want to use RubyGems < 2.0
  raise ERR_RG_2_REQUIRED unless spec.respond_to?(:metadata)

  spec.name         = "dry-service"
  spec.version      = DryServiceGem::VERSION.dup
  spec.date         = "2019-12-07"
  spec.summary      = ""
  spec.authors      = ["Jakub Żuchowski"]
  spec.email        = "ellmo@ellmo.net"
  spec.homepage     = "https://github.com/ellmo/dry-service"
  spec.license      = "MIT"
  # Fetch all git-versioned files, excluding all the default test locations.
  spec.files        = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.executables  = "dry-service"

  spec.required_ruby_version = ">= 2.5.0"

  spec.add_dependency "dry-monads", "~> 1.3"
  spec.add_dependency "dry-struct", "~> 1.1"
  spec.add_dependency "dry-types",  "~> 1.2"
  spec.add_dependency "thor",       "~> 0.19"

  spec.add_development_dependency "rspec", "~> 3.9"
end
