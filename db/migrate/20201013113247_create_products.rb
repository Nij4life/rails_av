class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.integer :ad_id
      t.string :name
      t.string :url
      t.string :city
      t.integer :year
      t.decimal :price
      t.string :photo_url
      t.text :description

      t.timestamps
    end
  end
end
