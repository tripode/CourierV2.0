# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120816225542) do

  create_table "areas", :force => true do |t|
    t.string  "area_name",   :limit => 50,  :null => false
    t.string  "description", :limit => 100
    t.integer "city_id"
  end

  create_table "cargo_manifest_details", :force => true do |t|
    t.integer "cargo_manifest_id"
    t.integer "transport_guide_id"
  end

  create_table "cargo_manifests", :force => true do |t|
    t.date    "created_at",      :null => false
    t.integer "manifest_num",    :null => false
    t.integer "origin_city_id"
    t.integer "destiny_city_id"
    t.integer "employee_id"
    t.integer "total_guides",    :null => false
    t.integer "total_products",  :null => false
    t.decimal "total_weight"
  end

  create_table "cities", :force => true do |t|
    t.string  "name",        :limit => 50, :null => false
    t.integer "province_id"
  end

  create_table "countries", :force => true do |t|
    t.string "name",        :limit => 60, :null => false
    t.string "description", :limit => 60
  end

  create_table "customer_types", :force => true do |t|
    t.string "type_name", :limit => 30
  end

  create_table "customers", :force => true do |t|
    t.string  "name",             :limit => 40
    t.string  "last_name",        :limit => 50
    t.string  "company_name",     :limit => 40
    t.string  "ruc",              :limit => nil
    t.string  "address",          :limit => 100
    t.integer "num_identify"
    t.string  "mobile_number",    :limit => 20
    t.string  "phone_number",     :limit => 20
    t.string  "email",            :limit => 60
    t.integer "customer_type_id"
  end

  create_table "employees", :force => true do |t|
    t.string  "email",            :limit => 60
    t.string  "name",             :limit => 30
    t.string  "last_name",        :limit => 30
    t.integer "num_identity"
    t.string  "address",          :limit => 60
    t.date    "admission_date"
    t.date    "birthday"
    t.decimal "salary"
    t.string  "mobile_number",    :limit => 20
    t.string  "phone_number",     :limit => 20
    t.integer "function_type_id"
  end

  create_table "function_types", :force => true do |t|
    t.string "description", :limit => 30, :null => false
  end

  create_table "invoice_details", :force => true do |t|
    t.integer "invoice_id"
    t.integer "retire_note_id"
    t.integer "sub_total"
  end

  create_table "invoices", :force => true do |t|
    t.datetime "date"
    t.integer  "customer_id"
    t.decimal  "total"
    t.string   "number"
    t.integer  "payment_method_id"
    t.decimal  "iva5"
    t.decimal  "iva10"
    t.string   "invoice_state"
  end

  create_table "payment_methods", :force => true do |t|
    t.string "name_payment", :limit => 20, :null => false
    t.string "description",  :limit => 50
  end

  create_table "product_states", :force => true do |t|
    t.string "state_name",  :limit => 20,  :null => false
    t.string "description", :limit => 100
  end

  create_table "product_types", :force => true do |t|
    t.string "description", :limit => 30, :null => false
  end

  create_table "products", :force => true do |t|
    t.string  "bar_code",            :limit => 50,  :null => false
    t.string  "description",         :limit => 100
    t.integer "product_type_id",                    :null => false
    t.integer "retire_note_id",                     :null => false
    t.string  "remitter",            :limit => 100
    t.integer "product_state_id",                   :null => false
    t.integer "receiver_id"
    t.date    "created_at",                         :null => false
    t.integer "receiver_address_id"
    t.date    "received_at"
  end

  add_index "products", ["bar_code"], :name => "index_products_on_bar_code", :unique => true

  create_table "provinces", :force => true do |t|
    t.string  "name",        :limit => 60, :null => false
    t.string  "description", :limit => 60
    t.integer "country_id"
  end

  create_table "reasons", :force => true do |t|
    t.string "description", :limit => 60, :null => false
  end

  create_table "receiver_addresses", :force => true do |t|
    t.string  "label",       :limit => 40
    t.string  "address"
    t.integer "city_id"
    t.integer "receiver_id"
  end

  create_table "receivers", :force => true do |t|
    t.string "receiver_name", :limit => 60, :null => false
    t.string "document",      :limit => 25
    t.date   "created_at"
    t.date   "updated_at"
  end

  create_table "retire_note_states", :force => true do |t|
    t.string "state_name", :limit => 30
  end

  create_table "retire_notes", :force => true do |t|
    t.integer "employee_id"
    t.date    "date"
    t.integer "service_type_id"
    t.integer "customer_id"
    t.date    "expiration_date"
    t.integer "product_type_id"
    t.integer "city_id"
    t.integer "amount"
    t.string  "description",          :limit => 50
    t.decimal "unit_price"
    t.integer "number"
    t.integer "retire_note_state_id"
    t.integer "amount_processed",                   :default => 0
  end

  add_index "retire_notes", ["number"], :name => "index_retire_notes_on_number", :unique => true

  create_table "roles", :force => true do |t|
    t.string "name", :limit => 30, :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "routing_sheet_details", :force => true do |t|
    t.integer "routing_sheet_id"
    t.integer "product_id"
    t.string  "who_received",     :limit => 40
    t.integer "reason_id"
    t.string  "received",         :limit => nil, :default => "n"
  end

  add_index "routing_sheet_details", ["routing_sheet_id"], :name => "index_routing_sheet_details_on_routing_sheet_id"

  create_table "routing_sheet_states", :force => true do |t|
    t.string "state_name",  :limit => 50,  :null => false
    t.string "description", :limit => 100
  end

  create_table "routing_sheets", :force => true do |t|
    t.integer "area_id",                               :null => false
    t.integer "employee_id",                           :null => false
    t.date    "date"
    t.integer "total_amount"
    t.integer "routing_sheet_state_id",                :null => false
    t.string  "commentary",             :limit => 100
    t.integer "number"
  end

  add_index "routing_sheets", ["date"], :name => "index_routing_sheets_on_date"

  create_table "service_types", :force => true do |t|
    t.string "description", :null => false
  end

  create_table "transport_guide_details", :force => true do |t|
    t.integer "transport_guide_id", :null => false
    t.integer "amount"
    t.integer "product_type_id",    :null => false
    t.decimal "weight"
    t.decimal "unit_cost",          :null => false
  end

  create_table "transport_guide_states", :force => true do |t|
    t.string "name_state",  :limit => 40,  :null => false
    t.string "description", :limit => 100
  end

  create_table "transport_guides", :force => true do |t|
    t.string  "destination_person",       :limit => 60
    t.string  "destination_address",      :limit => 100
    t.string  "remitter_person",          :limit => 60
    t.string  "remitter_address",         :limit => 100
    t.integer "num_guide",                               :null => false
    t.integer "customer_id",                             :null => false
    t.integer "employee_id",                             :null => false
    t.integer "service_type_id",                         :null => false
    t.integer "transport_guide_state_id",                :null => false
    t.integer "payment_method_id",                       :null => false
    t.integer "destination_city_id",                     :null => false
    t.integer "origin_city_id",                          :null => false
    t.integer "receiver_company_id",                     :null => false
    t.date    "created_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",               :default => "", :null => false
    t.string   "encrypted_password",  :default => "", :null => false
    t.datetime "remember_created_at"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "employee_id"
    t.string   "username"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  add_foreign_key "areas", "cities", :name => "areas_city_id_fk"

  add_foreign_key "cargo_manifest_details", "cargo_manifests", :name => "cargo_manifest_details_cargo_manifest_id_fk"
  add_foreign_key "cargo_manifest_details", "transport_guides", :name => "cargo_manifest_details_transport_guide_id_fk"

  add_foreign_key "cargo_manifests", "cities", :name => "fk_cargo_manifests_destiny_city_id", :column => "destiny_city_id"
  add_foreign_key "cargo_manifests", "cities", :name => "fk_cargo_manifests_origin_city_id", :column => "origin_city_id"
  add_foreign_key "cargo_manifests", "employees", :name => "cargo_manifests_employee_id_fk"

  add_foreign_key "cities", "provinces", :name => "cities_province_id_fk"

  add_foreign_key "customers", "customer_types", :name => "customers_customer_type_id_fk"

  add_foreign_key "employees", "function_types", :name => "employees_function_type_id_fk"

  add_foreign_key "invoice_details", "invoices", :name => "invoice_details_invoice_id_fk"
  add_foreign_key "invoice_details", "retire_notes", :name => "invoice_details_retire_note_id_fk"

  add_foreign_key "invoices", "customers", :name => "invoices_customer_id_fk"
  add_foreign_key "invoices", "payment_methods", :name => "invoices_payment_method_id_fk"

  add_foreign_key "products", "product_states", :name => "products_product_state_id_fk"
  add_foreign_key "products", "product_types", :name => "products_product_type_id_fk"
  add_foreign_key "products", "receiver_addresses", :name => "products_receiver_address_id_fk"
  add_foreign_key "products", "receivers", :name => "products_receiver_id_fk"
  add_foreign_key "products", "retire_notes", :name => "products_retire_note_id_fk"

  add_foreign_key "provinces", "countries", :name => "provinces_country_id_fk"

  add_foreign_key "receiver_addresses", "cities", :name => "receiver_addresses_city_id_fk"
  add_foreign_key "receiver_addresses", "receivers", :name => "receiver_addresses_receiver_id_fk"

  add_foreign_key "retire_notes", "cities", :name => "retire_notes_city_id_fk"
  add_foreign_key "retire_notes", "customers", :name => "retire_notes_customer_id_fk"
  add_foreign_key "retire_notes", "employees", :name => "retire_notes_employee_id_fk"
  add_foreign_key "retire_notes", "product_types", :name => "retire_notes_product_type_id_fk"
  add_foreign_key "retire_notes", "retire_note_states", :name => "retire_notes_retire_note_state_id_fk"
  add_foreign_key "retire_notes", "service_types", :name => "retire_notes_service_type_id_fk"

  add_foreign_key "roles_users", "roles", :name => "roles_users_role_id_fk"
  add_foreign_key "roles_users", "users", :name => "roles_users_user_id_fk"

  add_foreign_key "routing_sheet_details", "products", :name => "routing_sheet_details_product_id_fk"
  add_foreign_key "routing_sheet_details", "reasons", :name => "routing_sheet_details_reason_id_fk"
  add_foreign_key "routing_sheet_details", "routing_sheets", :name => "routing_sheet_details_routing_sheet_id_fk"

  add_foreign_key "routing_sheets", "areas", :name => "routing_sheets_area_id_fk"
  add_foreign_key "routing_sheets", "employees", :name => "routing_sheets_employee_id_fk"
  add_foreign_key "routing_sheets", "routing_sheet_states", :name => "routing_sheets_routing_sheet_state_id_fk"

  add_foreign_key "transport_guide_details", "product_types", :name => "transport_guide_details_product_type_id_fk"
  add_foreign_key "transport_guide_details", "transport_guides", :name => "transport_guide_details_transport_guide_id_fk"

  add_foreign_key "transport_guides", "cities", :name => "fk_transport_guides_destination_city_id", :column => "destination_city_id"
  add_foreign_key "transport_guides", "cities", :name => "fk_transport_guides_origin_city_id", :column => "origin_city_id"
  add_foreign_key "transport_guides", "customers", :name => "fk_transport_guides_receiver_company_id", :column => "receiver_company_id"
  add_foreign_key "transport_guides", "customers", :name => "transport_guides_customer_id_fk"
  add_foreign_key "transport_guides", "employees", :name => "transport_guides_employee_id_fk"
  add_foreign_key "transport_guides", "payment_methods", :name => "transport_guides_payment_method_id_fk"
  add_foreign_key "transport_guides", "service_types", :name => "transport_guides_service_type_id_fk"
  add_foreign_key "transport_guides", "transport_guide_states", :name => "transport_guides_transport_guide_state_id_fk"

  add_foreign_key "users", "employees", :name => "users_employee_id_fk"

end
