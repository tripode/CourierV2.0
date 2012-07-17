class AddReceivedAtProducts < ActiveRecord::Migration
  def up
    add_column :products, :received_at, :date, :null => true
  end

  def down
  end
end
