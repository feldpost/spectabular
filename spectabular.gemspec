# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "spectabular/version"

Gem::Specification.new do |s|
  s.name        = "spectabular"
  s.version     = Spectabular::VERSION
  s.authors     = ["Sebastian Friedrich"]
  s.email       = ["sebastian@feldpost.com"]
  s.homepage    = "http://github.com/feldpost/spectabular"
  s.summary     = %q{Generate tabular displays for Rails models}
  s.description = %q{Spectabular provides a helper method which turns ActiveModel resources into tabular displays. It provides some minimal customization options.}

  s.rubyforge_project = "spectabular"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
