ActiveRecord::Schema.define(version: 2020_10_13_120757) do

  create_table 'categories', force: :cascade do |t|
    t.string 'name'
    t.string 'url'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'categories_products', id: false, force: :cascade do |t|
    t.integer 'category_id', null: false
    t.integer 'product_id', null: false
    t.index ['category_id', 'product_id'], name: 'index_categories_products_on_category_id_and_product_id'
    t.index ['product_id', 'category_id'], name: 'index_categories_products_on_product_id_and_category_id'
  end

  create_table 'products', force: :cascade do |t|
    t.integer 'ad_id'
    t.string 'name'
    t.string 'url'
    t.string 'city'
    t.integer 'year'
    t.decimal 'price'
    t.string 'photo_url'
    t.text 'description'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

end
