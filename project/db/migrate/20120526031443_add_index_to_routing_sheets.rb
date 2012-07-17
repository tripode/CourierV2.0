class AddIndexToRoutingSheets < ActiveRecord::Migration
  def change
    add_index :routing_sheets, :date
  end
end
