# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "snowy_owl/version"

Gem::Specification.new do |spec|
  spec.name          = "snowy_owl"
  spec.version       = SnowyOwl::VERSION
  spec.authors       = ["Yi Han"]
  spec.email         = ["hanystudy@gmail.com"]

  spec.summary       = %q{Owl exploratory testing}
  spec.homepage      = "https://github.com/hanystudy/snowy_owl"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-rerun", "~> 1.1"
  spec.add_development_dependency "rubocop", "~> 0.49.1"
end
