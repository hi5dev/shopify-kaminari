module ShopifyAPI
  class Test < Base
  end
end

test_response = { "tests" => [] }.to_json

ActiveResource::HttpMock.respond_to do |mock|
  mock.get "/tests.json?page=1&per=25", {}, test_response
  mock.get "/tests/count.json", {}, { "count" => 0 }.to_json
end

ShopifyAPI::Base.site = "http://localhost"
