lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "spy_alley_application/version"

Gem::Specification.new 'spy_alley_application', '0.3.2' do |spec|
  spec.name          = 'spy_alley_application'
  spec.version       = SpyAlleyApplication::VERSION
  spec.authors       = ['Colin Horner']
  spec.email         = ['25807014+cmcolinh@users.noreply.github.com']

  spec.summary       = 'Spy Alley Application'
  spec.description   = 'Runs the Spy Alley Application'
  #spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = 'MIT'

  #spec.metadata["homepage_uri"] = spec.homepage
  #spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_dependency 'change_orders', '~> 0.1.0'
  spec.add_dependency 'dry-auto_inject'
  spec.add_dependency 'dry-initializer'
  spec.add_dependency 'dry-monads'
  spec.add_dependency 'dry-struct'
  spec.add_dependency 'dry-types'
  spec.add_dependency 'dry-validation'
  spec.add_dependency 'game_validator', '~> 0.6.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
