# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create 5 Users
5.times do |i|
  User.create!(
    email: "user#{i+1}@example.com",
    encrypted_password: BCrypt::Password.create("password#{i+1}")
  )
end

# Array of sample data for Rubberducks
names = ["Quackers", "Ducky", "Bubbles", "Splash", "Waddles", "Floaty", "Squeaky", "Sunny", "Puddles", "Rubber"]
cities = ["New York", "Paris", "Tokyo", "London", "Berlin", "Sydney", "Toronto", "Amsterdam", "Barcelona", "Rome"]
outfits = ["Superhero", "Princess", "Pirate", "Astronaut", "Chef", "Firefighter", "Doctor", "Ninja", "Cowboy", "Ballerina"]

# Create 20 Rubberducks
20.times do |i|
  Rubberduck.create!(
    name: names.sample,
    city: cities.sample,
    outfit: outfits.sample,
    price: rand(5..50),
    user_id: User.all.sample.id
  )
end
