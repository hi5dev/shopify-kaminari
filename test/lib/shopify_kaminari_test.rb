# coding: utf-8
# frozen_string_literal: true

require 'test_helper'

class Shopify::KaminariTest < Minitest::Test
  def test_default_collection_parser
    exp = Shopify::Kaminari::Collection
    act = ShopifyAPI::Base.collection_parser
    assert_equal(exp, act)
  end
end
