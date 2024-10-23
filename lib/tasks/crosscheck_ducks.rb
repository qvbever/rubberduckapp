require 'json'

# Load ducks from the database
ducks_in_db = Rubberduck.pluck(:name, :outfit)

# Load ducks from the JSON file
description_data = JSON.parse(File.read('db/duck_descriptions.json'))
ducks_in_json = description_data.map { |duck| [duck['name'], duck['outfit']] }

# Find ducks in the database but not in the JSON file
missing_in_json = ducks_in_db - ducks_in_json
puts "Ducks in DB but not in JSON:"
missing_in_json.each { |name, outfit| puts "#{name} (#{outfit})" }

# Find ducks in the JSON file but not in the database
missing_in_db = ducks_in_json - ducks_in_db
puts "Ducks in JSON but not in DB:"
missing_in_db.each { |name, outfit| puts "#{name} (#{outfit})" }
