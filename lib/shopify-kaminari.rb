require 'shopify_api'

module ShopifyAPI
  
  # add Kaminari pagination support to ShopifyAPI
  module Kaminari
    @@per = 25
    
    class << self
      # get limit of rows per page
      # @return [Integer] the per
      # @example Get the current per per page
      #   current_per = ShopifyAPI::Kaminari.per
      # @api public
      def per
        @@per
      end
      
      # set limit of rows to return per page
      # @param [Integer] value The new limit per row value
      # @return [Integer] the limit per row
      # @example Set limit per page to 50
      #   ShopifyAPI::Kaminari.per = 50
      # @api public
      def per=(value)
        @@per = value
      end
    end
    
    # paginates a ShopifyAPI::Base resource
    # @param [Hash, Integer] options Can be either a Hash like this: {:page => Integer, :per => Integer}, or the page number
    # @return [Array] Array of ShopifyAPI resources
    # @example Paginate all ShopifyAPI::Product
    #   @products = ShopifyAPI::Product.page :page => params[:page]
    # @example Paginate per 15
    #   @products = ShopifyAPI::Product.page :page => params[:page], :per => 15
    # @api public
    def paginate(options = {})
      options = {:page => options} if options.class == Fixnum
      options = {} if options.nil?
      
      # create params for pagination
      params = {
        :page   => options[:page] || 1,
        :limit  => options[:per]  || 25
      }
      
      # remove pagination params from options
      options.delete :page
      options.delete :per
      
      # merge any params from options
      params = params.merge options[:params] if options.include? :params
      
      # remove params from options
      filters = options.delete :params
      
      # create arguments to pass to ActiveResource find
      args = {:params => params}.merge options
      
      # run the query
      result = self.find :all, args
      
      # add instance methods to result Array to support paginating with Kaminari
      result.instance_eval <<-EVAL
        def current_page; #{args[:params][:page]}; end
        def total_pages; #{(self.count(filters).to_f / args[:params][:limit].to_f).ceil}; end
        def limit_value; #{args[:params][:limit]}; end
      EVAL
      
      result
    end
  end
  
end

ShopifyAPI::Base.send :extend, ShopifyAPI::Kaminari
