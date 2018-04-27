# coding: utf-8
# frozen_string_literal: true

module Shopify::Kaminari::Mocks
  SHOPIFY_API_USER_AGENT = [
    "ShopifyAPI/#{ShopifyAPI::VERSION}",
    "ActiveResource/#{ActiveResource::VERSION::STRING}",
    "Ruby/#{RUBY_VERSION}"
  ].join(' ')

  protected

  def shopify_api_mock(verb, path, body, *args)
    path = "/admin/#{path}"

    headers = shopify_api_request_headers

    http_mock.public_send(verb, path, headers, body, *args)
  end

  def shopify_domain
    @shopify_domain ||= 'test.myshopify.com'
  end

  def shopify_session
    ShopifyAPI::Session.temp(shopify_domain, shopify_token) { yield }
  end

  def shopify_token
    @shopify_token ||= SecureRandom.hex(16)
  end

  private

  def http_mock
    return @http_mock unless @http_mock.nil?

    ActiveResource::HttpMock.respond_to { |http_mock| @http_mock = http_mock }

    @http_mock
  end

  def shopify_api_request_headers
    {
      'Accept' => 'application/json',
      'User-Agent' => SHOPIFY_API_USER_AGENT,
      'X-Shopify-Access-Token' => shopify_token
    }.freeze
  end
end
