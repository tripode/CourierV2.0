class CreateProducts < ActiveRecord::Migration
  def change
   create_table "products", :force => true do |t|
    t.string  "bar_code",         :limit => 50,  :null => false
    t.string  "description",      :limit => 100
    t.integer "product_type_id",                 :null => false
    t.integer "retire_note_id",                  :null => false
    t.string  "remitter",         :limit => 100
    t.string  "fragile",          :limit => 5,   :null => false
    t.integer "product_state_id",                :null => false
    t.integer "receiver_id"
  
   
  end
  end
end
