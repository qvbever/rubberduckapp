class AddRatingToRubberducks < ActiveRecord::Migration[7.1]
  def change
    add_column :rubberducks, :rating, :decimal
  end
end
