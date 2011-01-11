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
  s.summary     = %q{Wrapper for Java's Executor Service classes}
  s.description = %q{Wrapper for Java's Executor Service classes allowing seamless integration with JRuby on Rails}

  s.files         = Dir['lib/**/*.rb']
  s.require_paths = ["lib"]
end