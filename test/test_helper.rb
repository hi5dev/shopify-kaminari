# coding: utf-8
# frozen_string_literal: true

# Disable Ruby's verbose warnings from unused variables, etc.
$VERBOSE = nil

# Start code coverage.
require 'coveralls'
Coveralls.wear! if Coveralls.will_run?

# Load the gem's library.
$LOAD_PATH << File.expand_path('../lib', __dir__)
require 'shopify-kaminari'

# Load the test framework.
require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

# Prevent live connections to the Shopify API.
ActiveResource::HttpMock.respond_to {}

# Load the test support files.
require_relative 'support/mocks'
