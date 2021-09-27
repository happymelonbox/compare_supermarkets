require 'pry'
require 'nokogiri'
require 'watir'

#gem install selenium-webdriver - required for watir to work
#brew install --cask chromedriver - required for watir to work

require_relative '../lib/compare_supermarkets/scraper'
require_relative '../lib/compare_supermarkets/product'
require_relative '../lib/compare_supermarkets/cli'
require_relative '../lib/compare_supermarkets/version'

Watir.default_timeout = 0
