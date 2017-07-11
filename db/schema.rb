# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170711214704) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", null: false
    t.integer "price", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name", null: false
    t.index ["cart_id", "product_id"], name: "index_cart_items_on_cart_id_and_product_id", unique: true
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "lock_version", default: 0, null: false
    t.index ["user_id"], name: "index_carts_on_user_id", unique: true
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.integer "quantity", null: false
    t.integer "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orderings", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "order_id"
    t.index ["order_id"], name: "index_orderings_on_order_id"
    t.index ["user_id"], name: "index_orderings_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "cod_fee", null: false
    t.integer "ship_fee", null: false
    t.string "ship_to_name", null: false
    t.string "ship_to_address", null: false
    t.date "ship_date", null: false
    t.string "ship_period", null: false
    t.float "tax_rate", default: 0.08, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_orderings", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "order_item_id"
    t.index ["order_item_id"], name: "index_product_orderings_on_order_item_id"
    t.index ["product_id"], name: "index_product_orderings_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.binary "image", null: false
    t.integer "price", null: false
    t.text "description", null: false
    t.boolean "hidden", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "ship_to_name", default: "", null: false
    t.string "ship_to_address", default: "", null: false
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "cart_items", "carts", on_delete: :cascade
  add_foreign_key "cart_items", "products"
  add_foreign_key "carts", "users", on_delete: :cascade
  add_foreign_key "order_items", "orders"
  add_foreign_key "product_orderings", "order_items"
  add_foreign_key "product_orderings", "products"
end
