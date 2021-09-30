class CompareSupermarkets::Scraper

    attr_accessor :search_term

    def initialize(search_term)
        @search_term = search_term
    end

    def self.search_supermarkets(search_term)
        supermarkets = ["Coles", "Woolworths", "IGA"]
        supermarkets.each do |supermarket|
            search_for(supermarket, search_term)
        end
    end

    def self.search_for(supermarket, search_term)
        open_browser(supermarket, search_term)
    end

    def self.open_browser(supermarket, search_term)
        browser = Watir::Browser.new :chrome
        if supermarket.downcase == "coles"
            search = "https://shop.coles.com.au/a/national/everything/search/#{search_term}"
            class_name = "products"
        elsif supermarket.downcase == "woolworths"
            search = "https://www.woolworths.com.au/shop/search/products?searchTerm=#{search_term}"
            class_name = "layoutWrapper"
        else
            search = "https://new.igashop.com.au/sm/pickup/rsid/53363/results?q=#{search_term}"
            class_name = ["Listing-sc-1vfhaq2", "iQljRa"]
        end
        browser.goto(search)
        self.handle_waiting(browser, supermarket, class_name, search_term)
    end

    def self.handle_waiting(browser, supermarket, class_name, search_term)
        begin
            js_doc = browser.element(class: class_name).wait_until(&:present?)
        rescue
            puts "#{supermarket} does not have any #{search_term}"
            puts ""
            puts ""
            if supermarket.downcase != "iga"
                puts "Let's check the next one"
            end
            puts ""
        else
            products = Nokogiri::HTML(js_doc.inner_html)
            self.add_supermarket_products(supermarket, products, search_term)
        ensure
            browser.close
        end
    end

    def self.add_supermarket_products(supermarket, products, search_term)
        new_supermarket = CompareSupermarkets::Supermarket.new(supermarket)
        self.which_supermarket(supermarket, products).each do |product|
            if check?(supermarket, product, search_term)
                new_supermarket.add_product(product)
            end
        end
        if new_supermarket.products.count == 0
            puts "#{supermarket} do not have any #{search_term}"
        end
    end

    def self.check?(supermarket, product, search_term)
        if supermarket.downcase == "coles"
            check = product.css(".product-name").text != ""
        elsif supermarket.downcase == "woolworths"
            check = product.css(".shelfProductTile-descriptionLink").text != ""
        else
            check = product.css(".sc-hKFyIo.bdDYJz").text.downcase[search_term]
        end
    end

    def self.which_supermarket(supermarket, products)
        if supermarket.downcase == "coles"
            all_products = products.css(".product")
        elsif supermarket.downcase == "woolworths"
            all_products = products.css(".shelfProductTile-content")
        else
            all_products = products.css(".ColListing-sc-lcurnl.kYBrWq")
        end
    end
end
