class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.boolean :recursive
      t.boolean :skip_products
      t.string :url_type
      t.string :state
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
