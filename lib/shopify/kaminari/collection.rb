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
  include ::Kaminari::ConfigurationMethods

  alias_method :model, :resource_class

  # Shopify returns this many records by default if no limit is given.
  DEFAULT_LIMIT_VALUE = 50

  ENTRIES_INFO_I18N_KEY = 'helpers.page_entries_info.entry'.freeze

  self.paginates_per(DEFAULT_LIMIT_VALUE)

  # The page that was requested from the API.
  #
  # @return [Integer] The current page.
  def current_page
    original_params.fetch(:page, 1).to_i
  end

  # @return [Integer] Current per-page number.
  def current_per_page
    limit_value
  end

  # Used for page_entries_info ActionView helper.
  #
  # @param [Hash] options Options provided by Kaminari.
  # @return [String] Numbers of displayed vs. total entries.
  def entry_name(options = {})
    options = options.reverse_merge(
      default: model_name.singular.pluralize(options[:count])
    )

    I18n.t(ENTRIES_INFO_I18N_KEY, options)
  end

  # @return [true, false] If on the first page.
  def first_page?
    current_page == 1
  end

  # @return [true, false] If on the last page.
  def last_page?
    current_page == total_pages
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
    current_page + 1 unless last_page? || out_of_range?
  end

  # Checks if the specified page is out of the range of the collection.
  #
  # @return [true, false] If out of range.
  def out_of_range?
    current_page > total_pages
  end

  # Fetches a new collection from the Shopify server using the same
  # parameters, except with a new value for limit.
  #
  # @param [Integer] limit New limit to apply to the collection.
  # @return [Shopify::Kaminari::Collection] Updated collection.
  def per(limit)
    params = original_params.with_indifferent_access.merge(limit: limit)

    resource_class.all(params: params)
  end

  # Gets the number of the previous page.
  #
  # @return [Integer, NilClass] The previous page number or nil if on the first.
  def prev_page
    current_page - 1 unless first_page? || out_of_range?
  end

  # Gets the total number of entries available on the server for the original
  # parameters used to fetch the collection.
  #
  # @return [Integer] Total number of entries.
  def total_count
    @total_count ||= begin
      # Get the parameters without the pagination parameters.
      options = original_params.with_indifferent_access.except(:page, :limit)

      # Ask Shopify how many records there are for the given query.
      count = resource_class.count(options)
    end
  end

  # Calculates the total number of expected pages based on the number
  # reported by the API.
  #
  # @return [Integer] Total number of pages.
  def total_pages
    @total_pages ||= (total_count.to_f / limit_value.to_f).ceil
  end
end
