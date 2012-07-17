class RemoveFragileFromProducts < ActiveRecord::Migration
  def up
    remove_column :products, :fragile
  end

  def down
  end
end
