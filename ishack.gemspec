# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'lib/ishack'
 
Gem::Specification.new do |s|
  s.name        = "ishack"
  s.version     = IShack::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michael Xavier"]
  s.email       = ["michael@michaelxavier.net"]
  s.homepage    = "http://github.com/michaelxavier/ishack"
  s.summary     = "Utility for uploading/transloading images to ImageShack"
  s.description = "IShack allows you to upload images stored locally or transload images stored remotely to the ImageShack hosting service"
 
  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency("nokogiri", ">= 1.3.2")
 
  s.add_development_dependency "rspec"
 
  s.files        = Dir.glob("{bin,lib,spec,features}/**/*") + %w(LICENSE README.rdoc CHANGELOG.rdoc cucumber.yml)
  s.bindir       = 'bin'
  s.executables  = ['ishack']
  s.require_path = 'lib'
end
