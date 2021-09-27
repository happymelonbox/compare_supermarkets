class CompareSupermarkets::Product
    attr_writer :price
    attr_reader :supermarket, :name, :price, :unit_size, :url, :dollar_value, :cent_value

    @@all = []
    @@coles_all = []
    @@woolworths_all = []

    def initialize (supermarket = nil, name = nil, price=nil, unit_size = nil, url = nil, dollar_value=nil, cent_value=nil)
        @supermarket = supermarket
        @name = name
        @price = price
        @unit_size = unit_size
        @dollar_value = dollar_value
        @cent_value = cent_value
        @url = @supermarket == "Coles" ? "https://shop.coles.com.au#{url}" : "https://www.woolworths.com.au#{url}"
        @@all << self
        if supermarket == "coles"
            @@coles_all << self
        else
            @@woolworths_all << self
        end
    end

    def self.all
        @all
    end

    def self.all_count
        @@all.count
    end
    
    def self.coles_new_from_search(product)
        product_to_compare = self.new("Coles", 
            product.css(".product-name").text,
            product.css(".package-price").text.delete_prefix('$').gsub('per', '/'),
            product.css(".package-size.accessibility-inline").text,
            product.css(".product-image-link").attribute('href'),
            product.css(".dollar-value").text,
            product.css(".cent-value").text.delete_prefix('.'))
    end

    def self.woolworths_new_from_search(product)
        product_to_compare = self.new("Woolworths", 
            product.css(".shelfProductTile-descriptionLink").text,
            product.css(".shelfProductTile-cupPrice.ng-star-inserted").text.delete_prefix(' $').chomp(" "),
            product.css(".shelfProductTile-descriptionLink").text.split(" ").last,
            product.css(".shelfProductTile-descriptionLink").attribute('href').value,
            product.css(".price-dollars").text,
            product.css(".price-cents").text)
    end

    def self.all_items_sorted_by_price
        sorted = @@all.sort_by!{|s| s.price.to_f}
    end

    def self.all_top_10_sorted_by_price
        self.all_items_sorted_by_price.first(10)
    end

    def self.coles_sorted_by_price
        @@coles_all.sort_by!{|s| s.price.to_f}
    end

    def self.woolworths_sorted_by_price
        @@woolworths_all.sort_by!{|s| s.price.to_f}
    end

    def self.clear_all
        @@all.clear
    end
end