class UpdateRoutingSheet < ActiveRecord::Migration
  def up
    remove_column :routing_sheets, :product_type_id
    add_column :routing_sheets, :commentary, :string, :limit => 100
  
  end

  def down
  end
end
