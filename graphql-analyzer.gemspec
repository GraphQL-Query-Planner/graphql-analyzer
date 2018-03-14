
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "graphql/analyzer/version"

Gem::Specification.new do |spec|
  spec.name          = "graphql-analyzer"
  spec.version       = GraphQL::Analyzer::VERSION
  spec.authors       = ["DerekStride"]
  spec.email         = ["djgstride@gmail.com"]

  spec.summary       = %q{An analysis tool for graphql-ruby schemas.}
  spec.description   = %q{An analysis tool for graphql-ruby schemas.}
  spec.homepage      = "https://github.com/GraphQL-Query-Planner/graphql-analyzer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "graphql", ">= 0.8", "< 2"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "factory_bot"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "mysql2"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "pg", "~> 0.18"
  spec.add_development_dependency "globalid"
end
