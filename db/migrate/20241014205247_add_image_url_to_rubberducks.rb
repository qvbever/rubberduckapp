class AddImageUrlToRubberducks < ActiveRecord::Migration[7.1]
  def change
    add_column :rubberducks, :image_url, :string
  end
end
