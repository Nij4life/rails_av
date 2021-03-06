# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_15_141356) do

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

  create_table 'tasks', force: :cascade do |t|
    t.boolean 'recursive'
    t.boolean 'skip_products'
    t.string 'url_type'
    t.string 'state'
    t.integer 'category_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['category_id'], name: 'index_tasks_on_category_id'
  end

  add_foreign_key 'tasks', 'categories'
end
