class CreateRubberducks < ActiveRecord::Migration[7.1]
  def change
    create_table :rubberducks do |t|
      t.string :name
      t.string :city
      t.string :outfit
      t.integer :price
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
