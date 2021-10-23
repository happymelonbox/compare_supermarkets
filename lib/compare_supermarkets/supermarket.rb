class CompareSupermarkets::Supermarket
    attr_accessor :name

    @@all = []
    @@products = []

    def initialize(name=nil)
        @name = name
        @@all << self
    end

    def self.all
        @@all
    end

    def self.all_products
        @@products
    end

    def self.products
        CompareSupermarkets::Product.all.select{|product| product.supermarket == self}
    end

    def self.clear_all
        @@all.clear
    end

    def add_product
        if @dollar_value != "0" && @cent_value != "0"
            new_product = CompareSupermarkets::Product.new(@supermarket, @name, @price, @unit_size, @url, @dollar_value, @cent_value)
            @@products << new_product
        end
    end
end

class CompareSupermarkets::Coles < CompareSupermarkets::Supermarket

    def initialize(product)
        @product = product
        @supermarket = self
        @name = @product.css(".product-name").text
        @price = @product.css(".package-price").text.delete_prefix('$').gsub('per', '/')
        @unit_size = @product.css(".package-size.accessibility-inline").text.chomp(' ')
        @url = "https://shop.coles.com.au#{@product.css(".product-image-link").attribute('href')}"
        @dollar_value = @product.css(".dollar-value").text
        @cent_value = @product.css(".cent-value").text.delete_prefix('.')
    end
end

class CompareSupermarkets::Woolworths < CompareSupermarkets::Supermarket

    def initialize(product)
        @product = product
        @supermarket = self
        @name = @product.css(".shelfProductTile-descriptionLink").text
        @price = @product.css(".shelfProductTile-cupPrice.ng-star-inserted").text.delete_prefix(' $').chomp(" ")
        @unit_size = @product.css(".shelfProductTile-descriptionLink").text.split(" ").last
        @url = "https://www.woolworths.com.au#{@product.css(".shelfProductTile-descriptionLink").attribute('href').value}"
        @dollar_value = @product.css(".price-dollars").text
        @cent_value = @product.css(".price-cents").text
    end
end