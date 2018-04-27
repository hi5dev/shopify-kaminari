# coding: utf-8
# frozen_string_literal: true

require 'shopify_api'

module Shopify
  module Kaminari
    autoload :Collection, 'shopify/kaminari/collection'
    autoload :VERSION, 'shopify/kaminari/version'
  end
end

# Set the Shopify API's default collection parser.
ShopifyAPI::Base.collection_parser = Shopify::Kaminari::Collection
