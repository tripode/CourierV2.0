class AddIndexToRoutingDetails < ActiveRecord::Migration
  def change
    add_index :routing_sheet_details, :routing_sheet_id
  end
end
