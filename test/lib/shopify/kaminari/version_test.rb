# coding: utf-8
# frozen_string_literal: true

require 'test_helper'

class Shopify::Kaminari::VersionTest < Minitest::Test
  def test_version_is_semantic
    regex = /^([0-9]+)\.([0-9]+)\.([0-9]+)?$/
    assert_match regex, Shopify::Kaminari::VERSION
  end
end
