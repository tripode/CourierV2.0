class AddAddressToProduct < ActiveRecord::Migration
  def change
    add_column :products, :receiver_address_id, :integer
    add_foreign_key :products, :receiver_addresses
  end
end
