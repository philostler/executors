# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "executors/version"

Gem::Specification.new do |s|
  s.name        = "executors"
  s.version     = Executors::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Phil Ostler"]
  s.email       = ["philostler@gmail.com"]
  s.homepage    = "https://github.com/philostler/executors"
  s.summary     = %q{Java Executor framework wrapper for JRuby}
  s.description = %q{Wrapper for Java's Executor framework allowing seamless integration with JRuby and Rails}

  s.has_rdoc = true
  s.rdoc_options << "--line-numbers"

  s.files         = Dir["**/*.rb"] + Dir["*.rdoc"] + Dir["lib/**/*.yml"]  + Dir["LICENSE"]
  s.require_paths = ["lib"]

  s.add_dependency "kwalify", ">= 0.7.2"
  s.add_development_dependency "rspec", ">= 2.5.0"
end