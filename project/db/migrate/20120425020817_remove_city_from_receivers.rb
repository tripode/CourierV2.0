class RemoveCityFromReceivers < ActiveRecord::Migration
  def up
    remove_column :receivers, :city_id
      end

  def down
    add_column :receivers, :city_id, :integer
  end
end
