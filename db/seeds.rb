
# Clear existing Rubberduck entries
Rubberduck.destroy_all

require 'json'

# Load scraped rubber duck data
if File.exist?("rubberducks.json")
  rubberduck_data = JSON.parse(File.read("rubberducks.json"), symbolize_names: true)

  rubberduck_data.each do |duck|
    Rubberduck.create!(
      name: duck[:name],
      outfit: duck[:outfit],    # Scraped outfit (from the title)
      image_url: duck[:image_url],
      price: rand(5..50),
      city: duck[:city],        # Include city
      user_id: User.all.sample.id,
      rating: rand(0.0..5.0).round(1)  # Random decimal rating between 0 and 5
    )
  end
else
  puts "No rubber ducks data found. Please run the scrape task first."
end
