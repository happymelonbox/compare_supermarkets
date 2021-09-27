class CompareSupermarkets::Scraper

    attr_accessor :search_term

    def initialize(search_term)
        @search_term = search_term
    end

    def self.search_supermarkets(search_term)
        self.search_coles_for(search_term)
        self.search_woolworths_for(search_term)
    end

    def self.search_coles_for(search_term)
        browser = Watir::Browser.new :chrome
        browser.goto("https://shop.coles.com.au/a/national/everything/search/#{search_term}")
        coles_js_doc = browser.element(class: "products").wait_until(&:present?)
        coles_products = Nokogiri::HTML(coles_js_doc.inner_html)
        all_coles_products = coles_products.css(".product")
        all_coles_products.each do |product|
            if product.css(".product-name").text != ""
                CompareSupermarkets::Product.coles_new_from_search(product)
            end
        end
        browser.close
    end

    def self.search_woolworths_for(search_term)
        browser = Watir::Browser.new :chrome
        browser.goto("https://www.woolworths.com.au/shop/search/products?searchTerm=#{search_term}")
        woolworths_js_doc = browser.element(class: "layoutWrapper").wait_until(&:present?)
        woolworths_products = Nokogiri::HTML(woolworths_js_doc.inner_html)
        woolworths_all_products = woolworths_products.css(".shelfProductTile-content")
        woolworths_all_products.each do |product|
            if product.css(".shelfProductTile-descriptionLink").text != ""
                if product.css(".unavailableSection.width-full.ng-star-inserted").empty?
                    CompareSupermarkets::Product.woolworths_new_from_search(product)
                end
            end
        end
        browser.close
    end
end
