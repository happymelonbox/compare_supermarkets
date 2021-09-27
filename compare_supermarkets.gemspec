# frozen_string_literal: true

require_relative "lib/compare_supermarkets/version"

Gem::Specification.new do |spec|
  spec.name          = "compare_supermarkets"
  spec.version       = CompareSupermarkets::VERSION
  spec.authors       = ["Justin Berger Howes"]
  spec.email         = ["happymelonbox@gmail.com"]
  spec.platform = Gem::Platform::RUBY
  spec.summary       = "Compare supermarket prices"
  spec.description   =
  "Will search Woolworths and Coles online stores for prices based on an input search parameter
  # CompareSupermarkets

Ever wondered 'I wonder if my shampoo is cheaper at Coles or Woolworths...?' ? But can't be
bothered searching both websites and comparing? Well that's what this gem does for you. Simply
install and follow the prompts.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'compare_supermarkets'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install compare_supermarkets

## Usage

To use compare_supermarkets call $ 'compare_supermarkets'
and follow the prompts. The more specific you are the faster the search results appear
and there will be less items to compare.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/happymelonbox/compare_supermarkets

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org
/licenses/MIT).
"
  spec.homepage      = "http://rubygems.org/gems/compare_supermarkets"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/happymelonbox/compare_supermarkets"
  spec.metadata["changelog_uri"] = "https://github.com/happymelonbox/compare_supermarkets/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.glob("{lib,bin,config}/**/*")
  spec.bindir        = "bin"
  spec.executables   = ['compare_supermarkets']
  spec.require_paths = ['lib', 'config']
  spec.add_development_dependency "bundler", "~> 2.2.28"
  spec.add_development_dependency "rake", "~> 13.0.6"
  spec.add_development_dependency "rspec", "~> 3.10.0"
  spec.add_development_dependency "nokogiri", ">= 1.10.8"
  spec.add_development_dependency "pry", ">= 0"

end
