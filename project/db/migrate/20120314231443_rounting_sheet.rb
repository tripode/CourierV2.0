class RountingSheet < ActiveRecord::Migration
  def up
    add_column :routing_sheets,:product_type_id, :integer
  end

  def down
  end
end
