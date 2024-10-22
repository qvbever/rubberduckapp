class AddCoordinatesToRubberducks < ActiveRecord::Migration[7.1]
  def change
    add_column :rubberducks, :latitude, :float
    add_column :rubberducks, :longitude, :float
  end
end
