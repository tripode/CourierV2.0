class UpdateRoutingSheetDetail < ActiveRecord::Migration
  def up
    remove_column :routing_sheet_details, :comentary
    add_column :routing_sheet_details, :received, :varchar, :limit => 1, :default => 'n'
  end

  def down
  end
end
