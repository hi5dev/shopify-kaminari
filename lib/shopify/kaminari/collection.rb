# coding: utf-8
# frozen_string_literal: true

# Shopify resources are paginated server-side. This custom
# +ActiveResource::Collection+ provides pagination that is compatible with the
# "kaminari" gem. Requiring this gem in your project configures the ShopifyAPI
# so that every Shopify resource will use this collection by default.
#
# @example Paginating products.
#   products = Shopify::Product.all(params: { page: 2, limit: 25 })
class Shopify::Kaminari::Collection < ActiveResource::Collection
  alias_method :model, :resource_class

  # Shopify returns this many records by default if no limit is given.
  DEFAULT_LIMIT_VALUE = 50

  # The page that was requested from the API.
  #
  # @return [Integer] The current page.
  def current_page
    @current_page ||= original_params.fetch(:page, 1).to_i
  end

  # The maximum amount of records each page will have.
  #
  # @return [Integer] Maximum amount of resources per page.
  def limit_value
    @limit_value ||= original_params.fetch(:limit, DEFAULT_LIMIT_VALUE).to_i
  end

  # Provides a Rails compatible model name for Kaminari's view helpers.
  #
  # @return [ActiveModel::Name] The model's name.
  def model_name
    @model_name ||= begin
      # Find the name of the resource with the ShopifyAPI:: prefix.
      name = resource_class.name.rpartition('::').last

      # Providing the name prevents every name from being prefixed with
      # "shopify_api_".
      ActiveModel::Name.new(resource_class, nil, name)
    end
  end

  # Gets the number of the next page.
  #
  # @return [Integer, NilClass] The next page number, or nil if on the last.
  def next_page
    @next_page ||= current_page + 1 if current_page < total_pages
  end

  # Gets the number of the previous page.
  #
  # @return [Integer, NilClass] The previous page number or nil if on the first.
  def prev_page
    @prev_page ||= current_page - 1 if current_page > 1
  end

  # Calculates the total number of expected pages based on the number
  # reported by the API.
  #
  # @return [Integer] Total number of pages.
  def total_pages
    @total_pages ||= begin
      # Get the parameters without the pagination parameters.
      params = original_params.with_indifferent_access.except(:page, :limit)

      options = params.empty? ? {} : params

      # Ask Shopify how many records there are for the given query.
      count = resource_class.count(options)

      # Calculate the number of pages.
      (count.to_f / limit_value.to_f).ceil
    end
  end
end
