class CompareSupermarkets::Supermarket
    attr_accessor :name

    @@all = []

    def initialize(name=nil)
        @name = name
        @@all << self
        @products = []
    end

    def add_product(product, search_term = "")
        if self.name == "Coles"
            new_product = CompareSupermarkets::Product.new(self,
                product.css(".product-name").text,
                product.css(".package-price").text.delete_prefix('$').gsub('per', '/'),
                product.css(".package-size.accessibility-inline").text.chomp(' '),
                product.css(".product-image-link").attribute('href'),
                product.css(".dollar-value").text,
                product.css(".cent-value").text.delete_prefix('.'))
        elsif self.name == "Woolworths"
            new_product = CompareSupermarkets::Product.new(self,
                product.css(".shelfProductTile-descriptionLink").text,
                product.css(".shelfProductTile-cupPrice.ng-star-inserted").text.delete_prefix(' $').chomp(" "),
                product.css(".shelfProductTile-descriptionLink").text.split(" ").last,
                product.css(".shelfProductTile-descriptionLink").attribute('href').value,
                product.css(".price-dollars").text,
                product.css(".price-cents").text)
        else
            price_css = if product.css(".ProductCardPrice-sc-zgh1l1.hwVjs").text.delete_prefix("$").split(".").first
                        ".ProductCardPrice-sc-zgh1l1.hwVjs" 
                    else
                        ".ProductCardPrice-sc-zgh1l1.jYaBFk"
                    end
            new_product = CompareSupermarkets::Product.new(self,
                product.css(".ProductCardTitle-sc-ye20s3.IDyAF").text.split(', ').first,
                product.css(".ProductCardPriceInfo-sc-1o21dmb.iDDqhD").text.delete_prefix("$").gsub("/", " / "),
                product.css(".ProductCardTitle-sc-ye20s3.IDyAF").text.split(', ').last,
                product.css(".ProductCardHiddenLink-sc-y1ynto.hGUSDV").attribute('href').value,
                product.css(price_css).text.delete_prefix("$").split(".").first,
                product.css(price_css).text.split(".").last.chomp(" avg/ea")
            )
        end
        p new_product
        @products << new_product
    end

    def products
        CompareSupermarkets::Product.all.select{|product| product.supermarket == self}
    end

    def self.clear_all
        @@all.clear
    end

end