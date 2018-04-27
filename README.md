# Shopify::Kaminari

Makes the [shopify_api gem](https://github.com/shopify/shopify_api) compatible
with the [kaminari](https://github.com/kaminari/kaminari) pagination gem.

## Installation

Add this line to your application's Gemfile:

    gem 'shopify-kaminari'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shopify-kaminari

## Usage

Just `require "shopify-kaminari"` in your project, and you're good to go! If 
you're using a Bundler backed project, like Rails, then you don't have to 
even do that much. Just add the gem to your Gemfile, and all of your Shopify 
resources will be paginatable with Kaminari.

Example:

```ruby
ShopifyAPI::Session.temp(domain, token) do
  @products = ShopifyAPI::Product.all(params: { page: 2, limit: 250 })
end
```

### Rails Example

Here's a simplified example of how to paginate a Shopify product in a Rails 
controller: 

```ruby
class ProductsController < ApplicationController
  around_action :shopify_session

  def index
    @products = ShopifyAPI::Product.all(params: pagination_params)
  end
  
  private

  def current_shop
    @current_shop ||= Shop.find_by(id: session[:shop_id])
  end
  
  def pagination_params
    params.slice(:page, :limit).permit!
  end
  
  def shopify_session(&block)
    ShopifyAPI::Session.temp(current_shop.domain, current_shop.token, &block)
  end
end
```

Then you could paginate the products in the view as you would with any other 
model:

```erb
<%= paginate(@products) %>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, 
run `rake test` to run the tests. You can also run `bin/console` for an 
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/hi5dev/shopify-kaminari.
