# coding: utf-8
# frozen_string_literal: true

require 'test_helper'

class Shopify::Kaminari::CollectionTest < Minitest::Test
  include Shopify::Kaminari::Mocks

  def teardown
    ActiveResource::HttpMock.reset!
  end

  def test_default_current_page
    assert_equal 1, fetch_products.current_page
  end

  def test_default_limit_value
    assert_equal 50, fetch_products.limit_value
  end

  def test_current_page
    assert_equal 2, fetch_products(page: 2).current_page
  end

  def test_limit_value
    assert_equal 25, fetch_products(limit: 25).limit_value
  end

  def test_model
    assert_equal ShopifyAPI::Product, fetch_products.model
  end

  def test_model_name
    model_name = fetch_products.model_name

    assert_kind_of ActiveModel::Name, model_name
    assert_equal 'product', model_name.singular
    assert_equal 'products', model_name.plural
  end

  def test_next_page
    shopify_session do
      assert_equal 2, fetch_products(page: 1).next_page
      assert_nil fetch_products(page: 3).next_page
    end
  end

  def test_prev_page
    assert_nil fetch_products(page: 1).prev_page
    assert_equal 2, fetch_products(page: 3).prev_page
  end

  def test_total_pages
    shopify_session do
      assert_equal 3, fetch_products.total_pages
      assert_equal 6, fetch_products(limit: 25).total_pages
      assert_equal 127, fetch_products(limit: 1).total_pages
    end
  end

  def test_total_pages_with_query
    query = { status: 'any' }
    count_path = "products/count.json?#{query.to_query}"
    count_json = { count: 500 }.to_json

    shopify_session do
      shopify_api_mock :get, count_path, count_json
      assert_equal 10, fetch_products(query).total_pages
    end
  end

  private

  # @return [Array<Hash>] List of attributes for fake products.
  def fake_products
    @fake_products ||= 127.times.map { { id: SecureRandom.uuid } }
  end

  # @param [Hash] params Pagination parameters.
  # @return [Shopify::Collection<ShopifyAPI::Product>]
  def fetch_products(params={})
    shopify_session do
      mock_products_call(params)

      ShopifyAPI::Product.all(params: params)
    end
  end

  # @param [Hash] params Pagination parameters.
  # @return [void]
  def mock_products_call(params)
    products_path = 'products.json'
    products_path += "?#{params.to_query}" unless params.empty?

    page ||= 1
    limit ||= Shopify::Kaminari::Collection::DEFAULT_LIMIT_VALUE
    first = (page - 1) * limit
    products = { products: fake_products[first..first+limit-1] }.to_json

    count = { count: 127 }.to_json
    count_path = 'products/count.json'

    shopify_api_mock :get, products_path, products
    shopify_api_mock :get, count_path, count
  end
end
