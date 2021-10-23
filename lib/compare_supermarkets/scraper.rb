class CompareSupermarkets::Scraper

    attr_accessor :search_term

    def initialize(search_term)
        @search_term = search_term
    end

    def self.search_supermarkets(supermarkets, search_term)
        supermarkets.each do |supermarket|
            new_supermarket = Kernel.const_get("CompareSupermarkets::#{supermarket}Scraper").new(search_term)
            new_supermarket.search_browser
        end
    end

    def handle_waiting(supermarket, class_name, all_products, search, search_term, check)
        browser = Watir::Browser.new :chrome
        begin
            browser.goto(search+search_term)
            js_doc = browser.element(class: class_name).wait_until(&:present?)
        rescue
            puts "This product cannot be found"
            puts ""
        else
            new_supermarket = Kernel.const_get("CompareSupermarkets::#{supermarket}").new(supermarket)
            products = Nokogiri::HTML(js_doc.inner_html)
            products.css(all_products).each do |product|
                if product.css(check).text != ""
                    new_supermarket.add_product(product)
                end
            end
            if new_supermarket.products.count == 0
                puts "#{supermarket} do not have this item"
            end
        ensure
            browser.close
        end
    end

    def search_browser
        handle_waiting(@supermarket, @class_name, @all_products, @search, @search_term, @check)
    end
end

class CompareSupermarkets::ColesScraper < CompareSupermarkets::Scraper

    def initialize(search_term)
        @supermarket = 'Coles'
        @search = "https://shop.coles.com.au/a/national/everything/search/"
        @search_term = search_term
        @class_name = "products"
        @all_products = ".product"
        @check = ".product-name"
    end

end

class CompareSupermarkets::WoolworthsScraper < CompareSupermarkets::Scraper

    def initialize(search_term)
        @supermarket = 'Woolworths'
        @search = "https://www.woolworths.com.au/shop/search/products?searchTerm="
        @search_term = search_term
        @class_name = "layoutWrapper"
        @all_products = ".shelfProductTile-content"
        @check = ".shelfProductTile-descriptionLink"
    end

end

