# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "spectabular/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "spectabular"
  s.version     = Spectabular::VERSION
  s.authors     = ["Sebastian Friedrich"]
  s.email       = ["sebastian@feldpost.com"]
  s.homepage    = "http://github.com/feldpost/spectabular"
  s.summary     = %q{Generate tabular displays for Rails models}
  s.description = %q{Spectabular provides a helper method which turns ActiveModel resources into tabular displays. It provides some minimal customization options.}


  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", '~> 3.0'

  s.add_development_dependency "sqlite3"
end
