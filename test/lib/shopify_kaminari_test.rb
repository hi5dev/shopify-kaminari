# coding: utf-8
# frozen_string_literal: true

require 'test_helper'

class Shopify::KaminariTest < Minitest::Test
  def test_default_collection_parser
    exp = Shopify::Kaminari::Collection
    act = ShopifyAPI::Base.collection_parser
    assert_equal(exp, act)
  end

  def test_api_base_page
    assert_respond_to ShopifyAPI::Base, :page
  end
end
