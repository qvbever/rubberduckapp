class AddDescriptionToRubberducks < ActiveRecord::Migration[7.1]
  def change
    add_column :rubberducks, :description, :string
  end
end
