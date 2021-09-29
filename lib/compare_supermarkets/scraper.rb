class CompareSupermarkets::Scraper

    attr_accessor :search_term

    def initialize(search_term)
        @search_term = search_term
    end

    def self.search_supermarkets(search_term)
        self.search_coles_for(search_term)
        self.search_woolworths_for(search_term)
        self.search_iga_for(search_term)
    end

    def self.search_coles_for(search_term)
        browser = Watir::Browser.new :chrome
        browser.goto("https://shop.coles.com.au/a/national/everything/search/#{search_term}")
        begin
            coles_js_doc = browser.element(class: "products").wait_until(&:present?)
        rescue
            puts "Coles does not have this product"
            puts ""
            puts "Let's check Woolworths"
            puts ""
            puts ""
        else
            coles_products = Nokogiri::HTML(coles_js_doc.inner_html)
            all_coles_products = coles_products.css(".product")
            coles = CompareSupermarkets::Supermarket.new("Coles")
            all_coles_products.each do |product|
                if product.css(".product-name").text != ""
                    coles.add_product(product)
                end
            end
            if coles.products.count == 0
                puts "Coles do not have this product"
            end
        ensure
            browser.close
        end
    end

    def self.search_woolworths_for(search_term)
        browser = Watir::Browser.new :chrome
        browser.goto("https://www.woolworths.com.au/shop/search/products?searchTerm=#{search_term}")
        begin
            woolworths_js_doc = browser.element(class: "layoutWrapper").wait_until(&:present?)
        rescue
            puts "Woolworths does not have this product"
        else
            woolworths_products = Nokogiri::HTML(woolworths_js_doc.inner_html)
            woolworths_all_products = woolworths_products.css(".shelfProductTile-content")
            woolworths = CompareSupermarkets::Supermarket.new("Woolworths")
            woolworths_all_products.each do |product|
                if product.css(".shelfProductTile-descriptionLink").text != ""
                    if product.css(".unavailableSection.width-full.ng-star-inserted").empty?
                        woolworths.add_product(product)
                    end
                end
            end
            if woolworths.products.count == 0
                puts "Woolworths do not have this product"
            end
        ensure
            browser.close
        end
    end

    def self.search_iga_for(search_term)
        browser = Watir::Browser.new :chrome
        browser.goto("https://new.igashop.com.au/sm/pickup/rsid/53363/results?q=#{search_term}")
        begin
            iga_js_doc = browser.element(class: ["Listing-sc-1vfhaq2", "iQljRa"]).wait_until(&:present?)
        rescue
            puts "iga does not have this product"
        else
            iga_products = Nokogiri::HTML(iga_js_doc.inner_html)
            iga_all_products = iga_products.css(".ColListing-sc-lcurnl.kYBrWq")
            iga = CompareSupermarkets::Supermarket.new("IGA")
            iga_all_products.each do |product|
                if product.css(".ProductCardTitle-sc-ye20s3.IDyAF").text != "" && product.css(".ProductCardTitle-sc-ye20s3.IDyAF").text.include?(search_term)
                    iga.add_product(product, search_term)
                end
            end
            if iga.products.count == 0
                puts "IGA do not have this product"
            end
        ensure
            browser.close
        end
    end
end
