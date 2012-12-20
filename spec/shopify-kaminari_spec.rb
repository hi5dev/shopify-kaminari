require 'spec_helper'

describe ShopifyAPI::Kaminari do
  
  describe "#per" do
    it "should default to 25" do
      described_class.per.should eq 25
    end
    it "should persist a custom value" do
      described_class.per.should_not eq 10
      described_class.per = 10
      described_class.per.should eq 10
    end
  end
  
  describe "#paginate" do
    it "should respond to current_page" do
      results = ShopifyAPI::Test.paginate
      results.should respond_to :current_page
    end
    it "should respond to total_pages" do
      results = ShopifyAPI::Test.paginate
      results.should respond_to :total_pages
    end
    it "should respond to limit_value" do
      results = ShopifyAPI::Test.paginate
      results.should respond_to :limit_value
    end
  end
  
end
