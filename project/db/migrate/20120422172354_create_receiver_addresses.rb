class CreateReceiverAddresses < ActiveRecord::Migration
  def change
    create_table :receiver_addresses do |t|
      t.integer :id
      t.string :label, limit: 40
      t.string :address
      t.integer :city_id
      t.integer :receiver_id

      t.timestamps
    end
    #add fk to receiver
    add_foreign_key :receiver_addresses, :receivers
    #add fk to cities
    add_foreign_key :receiver_addresses, :cities
    
  end
end
