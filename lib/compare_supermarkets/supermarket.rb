class CompareSupermarkets::Supermarket
    attr_accessor :name

    @@all = []

    def initialize(name=nil)
        @name = name
        @@all << self
        @products = []
    end

    def add_product(product)
        if self.name == "Coles"
            new_product = CompareSupermarkets::Product.new(self,
                product.css(".product-name").text,
                product.css(".package-price").text.delete_prefix('$').gsub('per', '/'),
                product.css(".package-size.accessibility-inline").text,
                product.css(".product-image-link").attribute('href'),
                product.css(".dollar-value").text,
                product.css(".cent-value").text.delete_prefix('.'))
        else
            new_product = CompareSupermarkets::Product.new(self,
                product.css(".shelfProductTile-descriptionLink").text,
                product.css(".shelfProductTile-cupPrice.ng-star-inserted").text.delete_prefix(' $').chomp(" "),
                product.css(".shelfProductTile-descriptionLink").text.split(" ").last,
                product.css(".shelfProductTile-descriptionLink").attribute('href').value,
                product.css(".price-dollars").text,
                product.css(".price-cents").text)
        end
        @products << new_product
    end

    def products
        CompareSupermarkets::Product.all.select{|product| product.supermarket == self}
    end

    def self.clear_all
        @@all.clear
    end

end