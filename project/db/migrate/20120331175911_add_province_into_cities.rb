class AddProvinceIntoCities < ActiveRecord::Migration
  def up
    remove_column :cities, :department
    add_column :cities, :province_id, :integer
    add_foreign_key :cities, :provinces
  end

  def down
  end
end
