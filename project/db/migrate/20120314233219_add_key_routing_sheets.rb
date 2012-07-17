class AddKeyRoutingSheets < ActiveRecord::Migration
  def up
      add_foreign_key :routing_sheets, :product_types
  end

  def down
  end
end
