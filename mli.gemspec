require_relative "lib/mli/version"

Gem::Specification.new do |spec|
  spec.name = "mli"
  spec.version = Mli::VERSION
  spec.authors = ["Jon Allured"]
  spec.email = ["jon@jonallured.com"]

  spec.summary = "Wrapper gem for the Monolithium API."
  spec.description = "This gem wraps the Monolithium API and provides CLI and classes to make working with that API nice."
  spec.homepage = "https://github.com/jonallured/mli"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jonallured/mli"
  spec.metadata["changelog_uri"] = "https://github.com/jonallured/mli"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
