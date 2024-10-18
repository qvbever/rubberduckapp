require 'nokogiri'
require 'open-uri'
require 'json'
require 'fileutils'

namespace :scrape do
  desc "Scrape rubber duck outfits and images from the Amsterdam Duck Store"
  task rubberducks: :environment do
    # Change the base_url to include pagination support (this will loop through pages)
    base_url = 'https://amsterdamduckstore.com/rubber-ducks/rubber-ducks/?paged='

    # Set the maximum number of pages you want to scrape (adjust this number as needed)
    max_pages = 10 # You can increase this number if there are more pages to scrape

    # Array of sample cities
    cities = [
      "New York", "Paris", "Tokyo", "London", "Berlin", "Sydney", "Toronto", "Amsterdam",
      "Barcelona", "Rome", "Miami", "Copenhagen", "Cape Town", "Vancouver", "Buenos Aires",
      "Lisbon", "Helsinki", "Vienna", "Bangkok", "Venice", "Prague", "Athens", "Kyoto",
      "Dublin", "Oslo", "Reykjavik", "Madrid", "San Francisco", "Tokyo", "Rotterdam",
      "Stockholm", "Marrakesch", "Istanbul", "Brussels", "Bordeaux", "San Sebastian",
      "Valencia", "Nashville", "Los Angeles"]

    # Array of random names for ducks
    random_names = ["Quackers", "Splashy", "Duck Norris", "Captain Feathers",
    "Flappy", "Waddles", "Bubbles", "Sir Quackalot", "Ducky McDuckface", "Fluffy",
    "Wingman", "Featherstorm", "Quack Sparrow", "Puddle Jumper", "Bill Murray",
    "Flapjack", "Waterfowl", "Captain Quack", "Duck Vader", "Beaksy", "Sir Waddlesworth",
    "Featherface", "Mr. Quackers", "Plucky", "Drake", "Pond King", "AquaDuck", "Waddleton",
    "Moby Duck", "The Great Quacksby", "Lady Quackalot", "Miss Peep", "Daisy Quack", "Quackabelle",
    "Bella Duck", "Goldie Feathers", "Madame Waddle", "Princess Splash", "Queen Quackers",
    "Pearl Paddles", "Flutter Wing", "Sweet Beak", "Rosie Ripple", "Featherina", "Daisy",
    "Puddle", "Lily", "Goldie", "Pearl", "Bella", "Lady Quack", "Miss Waddle", "Queenie",
    "Princess Plume", "Swanette", "Twirly"]

    # Initialize an array to store rubber duck data for JSON
    rubberduck_data = []

    # Directory to save images
    images_directory = Rails.root.join("app/assets/images/rubberducks")

    # Ensure the directory exists
    FileUtils.mkdir_p(images_directory)

    # Add a loop to iterate through each page
    (1..max_pages).each do |page_number|
      # Modify the URL to include the current page number in the loop
      url = base_url + page_number.to_s

      # Open and parse the HTML document
      html = URI.open(url)
      doc = Nokogiri::HTML(html)

      # Add a check to stop when no more ducks are found
      ducks_on_page = doc.css('.product').count
      break if ducks_on_page == 0 # Stop if no more ducks are found

      doc.css('.product').each do |item|
        title = item.css('.woocommerce-loop-product__title').text.strip

        # Randomly assign a name to the duck
        random_name = random_names.sample

        # Remove "Rubber Duck" from the title to create the outfit
        outfit = title.gsub("Rubber Duck", "").strip

        image_url = item.css('img').attr('src').value
        city = cities.sample # Randomly select a city

        # Assign a random user from the existing users
        random_user = User.all.sample

        # Generate a unique filename for the image
        filename = "#{outfit.downcase.gsub(' ', '_')}_#{random_name.downcase.gsub(' ', '_')}.jpg"
        local_image_path = images_directory.join(filename)

        # Download the image and save it locally
        begin
          URI.open(image_url) do |image|
            File.open(local_image_path, 'wb') do |file|
              file.write(image.read)
            end
          end
        rescue OpenURI::HTTPError => e
          puts "Error downloading image: #{e.message}"
          next
        end

        # Create the Rubberduck record in the database
        begin
          Rubberduck.create!(
            name: random_name,
            outfit: outfit,
            image_url: filename, # Save the local filename in the database
            city: city,
            user: random_user   # Assign the random user
          )

          # Collect data for JSON output
          rubberduck_data << {
            name: random_name,
            outfit: outfit,
            image_url: filename,
            city: city,
            price: rand(5..50) # Random price for the duck
          }
        rescue ActiveRecord::RecordInvalid => e
          puts "Error saving rubber duck: #{e.message}"
        end
      end

      # Print message after scraping each page
      puts "Finished scraping page #{page_number}"
    end

    # Write collected data to a JSON file
    File.write("rubberducks.json", rubberduck_data.to_json)

    puts "Ducks scraped and saved!"
  end
end
