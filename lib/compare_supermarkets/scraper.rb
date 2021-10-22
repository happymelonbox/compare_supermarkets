class CompareSupermarkets::Scraper

    attr_accessor :search_term

    def initialize(search_term)
        @search_term = search_term
    end

    def self.search_supermarkets(supermarkets, search_term)
        supermarkets.each do |supermarket|
        Kernel.const_get("CompareSupermarkets::#{supermarket}Scraper").search_browser(search_term)
        end
    end

    def self.handle_waiting(supermarket, class_name, all_products, search, check)
        browser = Watir::Browser.new :chrome
        begin
            browser.goto(search)
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
end

class CompareSupermarkets::ColesScraper < CompareSupermarkets::Scraper

    def self.search_browser(search_term)
        search = "https://shop.coles.com.au/a/national/everything/search/#{search_term}"
        class_name = "products"
        all_products = ".product"
        check = ".product-name"
        self.handle_waiting('Coles', class_name, all_products, search, check)
    end

end

class CompareSupermarkets::WoolworthsScraper < CompareSupermarkets::Scraper

    def self.search_browser(search_term)
        search = "https://www.woolworths.com.au/shop/search/products?searchTerm=#{search_term}"
        all_products = ".shelfProductTile-content"
        class_name = "layoutWrapper"
        check = ".shelfProductTile-descriptionLink"
        self.handle_waiting('Woolworths', class_name, all_products, search, check)
    end

end

