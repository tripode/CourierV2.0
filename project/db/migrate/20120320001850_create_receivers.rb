class CreateReceivers < ActiveRecord::Migration
  def change
    create_table :receivers do |t|
      t.integer :id
      t.string :receiver_name, :limit => 60, :null=> false
      t.string :address, :limit => 100, :null=> false
      t.integer :city_id
      t.string :document, :limit => 25, :null => true

    end
    add_foreign_key :receivers , :cities
  end
  
end
