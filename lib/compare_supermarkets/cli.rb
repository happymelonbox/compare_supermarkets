class CompareSupermarkets::CLI
    def call
        puts ""
        puts "Welcome to The Supermarket Comparer"
        puts ""
        puts "Type q at any time to exit."
        puts ""
        puts "Would you like to compare prices between Coles and Woolies? (Y/N)"
        input = gets.strip.downcase
        puts ""
        if input == "y"
            start
        elsif input == "n"
            puts ""
            puts "No worries, have a good one!"
            puts ""
            exit
        elsif input.empty?
            invalid_input
            call
        elsif input == "q"
            exit
        else
            invalid_input
            call
        end
    end

    def start
        puts ""
        puts "Great!"
        puts "Please enter the name of the item you wish to compare"
        input = gets.strip.downcase
        puts ""
        puts ""
        puts "Thank you, we will now search for this product"
        puts "This will open the browser, don't panic!"
        puts ""
        puts ""
        puts ""
        puts ""
        self.search_supermarkets(input)
        puts ""
        puts ""
        if CompareSupermarkets::Product.count > 10
            puts ""
            puts "Ooo, jeez, seems like we have a lot of results."
            puts "We have #{CompareSupermarkets::Product.count} results for you."
            puts "If you were a little more specific with your search"
            puts "term, we would have less to sort through..."
            puts ""
            change_search_term
        elsif CompareSupermarkets::Product.count == 0
            puts ""
            puts "Ohhh man! Doesn't seem like either supermarket carry"
            puts "that product."
            puts ""
            change_search_term
        else
            puts ""
            puts "Great! We have #{CompareSupermarkets::Product.count} items for you."
            puts ""
            puts ""
            puts ""
            how_to_display
        end
    end

    def search_supermarkets(input)
        CompareSupermarkets::Scraper.search_supermarkets(input)
    end

    def change_search_term
        puts "Would you like to change your search term? (Y/N)"
        input = gets.strip.downcase
        if input == "y"
            start
        elsif input == "n"
            puts ""
            puts "No worries"
            puts ""
            if CompareSupermarkets::Product.count > 0
                how_to_display
            else
                puts ""
                puts "Have a great day!"
                puts ""
                exit
            end
        elsif input.empty?
            invalid_input
            change_search_term
        elsif input == "q"
            exit
        else
            invalid_input
            change_search_term
        end
    end

    def how_to_display
        puts "How would you like your items displayed? (1-5)"
        puts ""
        puts "1 - First 10 Cheapest items"
        puts ""
        puts "2 - First 10 Most expensive items"
        puts ""
        puts "3 - All items"
        puts ""
        puts "4 - Only Coles items"
        puts ""
        puts "5 - Only Woolworths items"
        puts ""
        puts "6 - Only IGA items"
        puts ""
        input = gets.strip
        puts ""
        choice(input)
    end
    
    def choice(input)
        if input == "1"
            choice = CompareSupermarkets::Product.all_top_10_sorted_by_price
            print_items(choice, "asc")
        elsif input == "2"
            choice = CompareSupermarkets::Product.all_top_10_sorted_by_price
            print_items(choice, "desc")
        elsif input == "3"
            how_to_sort ? direction = "asc" : direction = "desc"
            choice = CompareSupermarkets::Product.all_items_sorted_by_price
            print_items(choice, direction)
        elsif input == "4"
            how_to_sort ? direction = "asc" : direction = "desc"
            choice = CompareSupermarkets::Product.coles_sorted_by_price
            print_items(choice, direction)
        elsif input == "5"
            how_to_sort ? direction = "asc" : direction = "desc"
            choice = CompareSupermarkets::Product.woolworths_sorted_by_price
            print_items(choice, direction)
        elsif input == "6"
            how_to_sort ? direction = "asc" : direction = "desc"
            choice = CompareSupermarkets::Product.iga_sorted_by_price
            print_items(choice, direction)
        elsif input == ""
            invalid_input
            how_to_display
        elsif input == "q"
            exit
        else
            invalid_input
            how_to_display
        end
    end

    def finished
        puts ""
        puts "Is this what you were looking for?(Y/N)"
        input = gets.strip.downcase
        if input == "y"
            puts ""
            puts "Great!"
            anything_else
        elsif input == "n"
            puts ""
            try_again
        elsif input == ""
            invalid_input
            finished
        elsif input == "q"
            exit
        else
            invalid_input
            finished
        end
    end

    def try_again
        puts "Oh damn, would you like to try something else? (Y/N)"
        input = gets.strip.downcase
        if input == "n"
            puts ""
            puts "I'm sorry we couldn't help you today. Have a wonderful day!"
            puts ""
            exit
        elsif input == "y"
            sort_or_compare
        elsif input == "q"
            exit
        elsif input == ""
            invalid_input
            try_again
        else
            invalid_input
        end
    end

    def sort_or_compare
        puts ""
        puts "Please pick from one of these options:"
        puts ""
        puts "1 - Change the which results you would like to see"
        puts ""
        puts "2 - Search for a new item"
        input = gets.strip
        if input == "1"
            how_to_display
        elsif input == "2"
            CompareSupermarkets::Product.clear_all
            CompareSupermarkets::Supermarket.clear_all
            start
        elsif input == ""
            invalid_input
            sort_or_compare
        else
            invalid_input
            sort_or_compare
        end
    end

    def anything_else
        puts "Can we help you compare anything else today? (Y/N)"
        answer = gets.strip.downcase
        if answer == "n"
            puts ""
            puts "Okay, thank you! Have a great day!"
            puts ""
            exit
        elsif answer == "y"
            start
        else
            invalid_input
            anything_else
        end
    end

    def invalid_input
        puts ""
        puts "Oh, I don't understand that input"
        puts ""
        puts "Please try again"
    end

    def how_to_sort
        puts ""
        puts "How would you like your results sorted?"
        puts "1 - Cheapest to most expensive"
        puts "2 - Most expensive to cheapest"
        puts ""
        input = gets.strip
        if input == "1"
            puts ""
            puts "Okay! Here we go!"
            puts ""
            return true
        elsif input == "2"
            puts ""
            puts "Okay! Here we go!"
            puts ""
            return false
        elsif input == ""
            puts ""
            puts "Please enter a command"
            how_to_sort
        else
            invalid_input
            how_to_sort
        end
    end

    def print_items(choice, direction)
        direction == "asc" ? choice = choice : choice = choice.reverse
        choice.each do |item|
            p "Supermarket: #{item.supermarket.name}"
            p "Item name: #{item.name}"
            p "Item price: $#{item.dollar_value}.#{item.cent_value}"
            p "Item unit size: #{item.unit_size}"
            p item.price.empty? ? "Unit price: $#{item.dollar_value}.#{item.cent_value} / #{item.unit_size}" : "Unit price: $#{item.price}"
            p "#{item.url}"
            puts ""
        end
        puts ""
        puts ""
        finished
    end

end