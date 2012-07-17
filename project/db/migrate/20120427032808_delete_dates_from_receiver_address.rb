class DeleteDatesFromReceiverAddress < ActiveRecord::Migration
  def up
    remove_column :receiver_addresses, :created_at
    remove_column :receiver_addresses, :updated_at
  end

  def down
  end
end
