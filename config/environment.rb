require 'pry'
require 'nokogiri'
require 'watir'

require_relative '../lib/compare_supermarkets/scraper'
require_relative '../lib/compare_supermarkets/product'
require_relative '../lib/compare_supermarkets/cli'
require_relative '../lib/compare_supermarkets/version'
require_relative '../lib/compare_supermarkets/supermarket'

Watir.default_timeout = 0
