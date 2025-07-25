# frozen_string_literal: true

require_relative "lib/rz/pennylane/version"

Gem::Specification.new do |spec|
  spec.name          = "rz-pennylane"
  spec.version       = Rz::Pennylane::VERSION
  spec.authors       = ["Eduard Garcia Castelló"]
  spec.email         = %w[edugarcas@gmail.com eduard@rzilient.club]

  spec.summary       = "Rz Pennylane gem"
  spec.description   = "Pennylane is a finance platform"
  spec.homepage      = "https://github.com/eddygarcas/ruby-pennylane"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.4.1")

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/eddygarcas/ruby-pennylane"
  spec.metadata["changelog_uri"] = "https://github.com/eddygarcas/ruby-pennylane"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "activesupport", ">= 8.0"
  spec.add_dependency "httparty", "~> 0.18"
  spec.add_dependency "rake", "~> 13.0"
  spec.add_dependency "rspec", "~> 3.0"
  spec.add_dependency "rubocop", "~> 1.7"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
