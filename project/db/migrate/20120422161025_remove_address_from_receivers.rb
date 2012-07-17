class RemoveAddressFromReceivers < ActiveRecord::Migration
  def up
    remove_column :receivers, :address
      end

  def down
    add_column :receivers, :address, :string
  end
end
