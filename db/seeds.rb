require 'json'

User.create!(email:"marko@gmail.com", password:"111111")
User.create!(email:"danko@gmail.com", password:"111111")

# Load scraped rubber duck data
if File.exist?("rubberducks.json")
  rubberduck_data = JSON.parse(File.read("rubberducks.json"), symbolize_names: true)

  # Load existing descriptions from the JSON file (if present)
  description_file = 'db/duck_descriptions.json'
  description_data = if File.exist?(description_file)
                       JSON.parse(File.read(description_file))
                     else
                       []
                     end

  # Extended description templates with placeholders for name and outfit
  description_templates = [
    "{{name}} is splashing around in the tub, wearing their favorite {{outfit}} outfit. They bring laughter and joy to every bubble-filled moment, turning an ordinary bath into a delightful experience. Whether you’re having a lazy soak or an energetic splash session, {{name}} makes sure there’s never a dull moment. With {{name}} by your side, bath time becomes an adventure filled with smiles, and their {{outfit}} adds that extra special touch to brighten up your day!",
    "Every bath is a fun adventure when {{name}} shows up in their {{outfit}} outfit. With their charming smile and playful energy, {{name}} turns the tub into a sea of excitement. You’ll never get tired of the antics and splashes they bring. {{name}} loves making bath time as entertaining as possible, and with their {{outfit}}, they always manage to make every soak a stylish one. Get ready to laugh, splash, and enjoy your time with the best bath buddy ever!",
    "Get ready for bath time fun with {{name}}! They’re all decked out in their {{outfit}} outfit, ready to turn every bubble into an opportunity for adventure. Bath time is no longer just a routine but a moment of laughter and creativity. {{name}} loves to dive into the water with style, and their {{outfit}} makes them look absolutely fabulous. Be prepared for endless giggles and a whole lot of splashing—{{name}} makes sure that bath time is anything but boring!",
    "With {{name}} in the tub, wearing their {{outfit}}, bath time will never be the same! They bring an infectious energy that makes the water feel alive with fun and adventure. Whether you’re soaking after a long day or just want some playful company, {{name}} is always there to add excitement to the mix. Their {{outfit}} makes them look even more adorable as they bob around, turning an everyday bath into a magical experience full of giggles, splashes, and wonderful memories!",
    "{{name}} makes waves in the water with their stylish {{outfit}} outfit. They’re not just any ordinary duck—they’re a trendsetter! When {{name}} hits the water, every splash has a hint of glamour, and the tub becomes their personal runway. From blowing bubbles to diving through the suds, {{name}} always knows how to put on a show. Bath time becomes an event you look forward to, with {{name}} bringing joy, excitement, and their impeccable style to make sure you have the most fabulous time ever!",
    "Quack! {{name}} is here, and they’re rocking their {{outfit}} outfit in the bath! Get ready for some serious bath time entertainment. {{name}} loves to splash around, turning the water into their own personal playground. With each playful quack and every stylish splash, they make sure you’re smiling from ear to ear. Their {{outfit}} adds that extra dash of flair, making every bath feel like a special occasion. With {{name}} around, the tub is the place to be for fun, laughter, and delightful memories!",
    "Watch out! {{name}} is about to make a splash in their amazing {{outfit}} outfit. Bath time will never be boring again with {{name}} diving, splashing, and showing off their outfit. They love to explore the bubbles and see how much fun they can bring to every soak. Their {{outfit}} makes them look so cool that you can’t help but smile. {{name}}’s energy is contagious, and before you know it, you’ll be laughing and splashing right along with them, making every bath an adventure you won’t forget!",
    "{{name}} is the coolest duck in the water with their {{outfit}} outfit. They have a way of bringing excitement and energy to every bath, making even a quick rinse feel like a grand event. Their {{outfit}} adds a touch of style that sets them apart, and they love to show it off as they glide through the water. With {{name}} by your side, bath time is filled with fun, laughter, and plenty of splashes. Get ready for a bath-time experience that’s cool, refreshing, and endlessly entertaining with the most stylish duck around!",
    "Splish splash! {{name}} arrives in style with their {{outfit}} outfit, ready to turn bath time into a festival of fun. They love making waves, diving through bubbles, and splashing about with joy. {{name}}’s energy makes every moment in the water more exciting, and their {{outfit}} adds that extra bit of charm that makes them truly one of a kind. Whether it’s a lazy soak or an energetic splash fest, {{name}} makes sure that bath time is something you look forward to—filled with laughter, joy, and plenty of bubbly memories!",
    "Bath time gets a lot more fun with {{name}} and their awesome {{outfit}} outfit. They bring an extra bit of magic to the water, making sure every splash is full of joy. {{name}} loves playing in the bubbles, and their {{outfit}} makes them look fantastic while they do it. Whether they’re floating along or diving under, {{name}} turns the ordinary into extraordinary. Get ready to make some memories as {{name}} transforms your bath into the most enjoyable and delightful part of your day!"
  ]

  # Helper method to generate a random description using the templates
  def generate_fallback_description(name, outfit, templates)
    template = templates.sample # Randomly pick one of the 10 templates
    template.gsub("{{name}}", name).gsub("{{outfit}}", outfit)
  end

  rubberduck_data.each do |duck|
    begin
      # Find matching description based only on outfit
      existing_description = description_data.find { |d| d['outfit'] == duck[:outfit] }

      # If no description is found for the outfit, generate a fallback description
      description = if existing_description
                      existing_description['description'].gsub("{{name}}", duck[:name])
                    else
                      generate_fallback_description(duck[:name], duck[:outfit], description_templates)
                    end

      # Create the Rubberduck record in the database
      Rubberduck.create!(
        name: duck[:name],
        outfit: duck[:outfit],    # Scraped outfit (from the title)
        image_url: duck[:image_url],
        price: rand(5..50),
        city: duck[:city],        # Include city
        user_id: User.all.sample.id,
        rating: rand(0.0..5.0).round(1),  # Random decimal rating between 0 and 5
        description: description # Use the description (from JSON or fallback)
      )
      puts "Created #{duck[:name]} with outfit #{duck[:outfit]} and description."
    rescue ActiveRecord::RecordInvalid => e
      puts "Error creating duck: #{e.message}"
    end
  end
else
  puts "No rubber ducks data found. Please run the scrape task first."
end
