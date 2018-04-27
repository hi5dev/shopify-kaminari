# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'shopify/kaminari/version'

Gem::Specification.new do |spec|
  spec.name = 'shopify-kaminari'
  spec.version = Shopify::Kaminari::VERSION
  spec.authors = ['Travis Haynes']
  spec.email = ['travis@hi5dev.com']
  spec.homepage = 'https://github.com/hi5dev/shopify-kaminari.git'
  spec.summary = %q{Provides shopify_api with pagination support via Kaminari}

  spec.bindir = 'exe'
  spec.require_paths = ['lib']

  spec.files = `git ls-files -z`.split("\x0").reject do |file|
    file.match(%r{^(test)/})
  end

  spec.executables = spec.files.grep(%r{^#{spec.bindir}/}) do |file|
    File.basename(file)
  end

  spec.add_dependency 'shopify_api'
  spec.add_dependency 'kaminari'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'minitest-reporters', '~> 1.2'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'simplecov', '~> 0.16'
  spec.add_development_dependency 'yard', '~> 0.9'
end
