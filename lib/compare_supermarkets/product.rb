class CompareSupermarkets::Product
    attr_accessor :supermarket, :name, :price, :unit_size, :url, :dollar_value, :cent_value

    @@all = []

    def initialize (supermarket = nil, name = nil, price=nil, unit_size = nil, url = nil, dollar_value=nil, cent_value=nil)
        @supermarket = supermarket
        @name = name
        @price = price
        @unit_size = unit_size
        @dollar_value = dollar_value
        @cent_value = cent_value
        @url = @supermarket.name == "Coles" ? "https://shop.coles.com.au#{url}" : "https://www.woolworths.com.au#{url}"
        @@all << self
    end

    def self.all
        @@all
    end

    def self.count
        @@all.count
    end

    def supermarket_name
        self.supermarket ? self.supermarket.name : nil
    end


    def self.all_items_sorted_by_price
        sorted = self.all.sort_by! do |s|
            price_to_sort = s.dollar_value + '.' + s.cent_value
            price_to_sort.to_f
        end
    end

    def self.all_top_10_sorted_by_price
        self.all_items_sorted_by_price.first(10)
    end

    def self.coles_sorted_by_price
        coles_items = self.all.select{|product| product.supermarket_name == "Coles"}
        coles_items.sort_by! do |s|
        price_to_sort = s.dollar_value + '.' + s.cent_value
        price_to_sort.to_f
        end
    end

    def self.woolworths_sorted_by_price
        woolworths_items = self.all.select{|product| product.supermarket_name == "Woolworths"}
        woolworths_items.sort_by! do |s|
            price_to_sort = s.dollar_value + '.' + s.cent_value
            price_to_sort.to_f
        end
    end

    def self.clear_all
        @@all.clear
    end
end