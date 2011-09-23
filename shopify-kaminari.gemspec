# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "shopify-kaminari"
  s.version     = "0.0.1"
  s.authors     = ["Travis Haynes"]
  s.email       = ["travis.j.haynes@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Provides shopify_api with pagination support via Kaminari}
  s.description = %q{Extends ShopifyAPI, adding support to paginate using the Kaminari gem.}

  s.rubyforge_project = "shopify-kaminari"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency("shopify_api", [">= 1.2.5"])
  s.add_dependency("kaminari", [">= 0.12.4"])
  s.add_dependency("rspec", [">= 2.6.0"])
end
