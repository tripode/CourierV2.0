class AddCityToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :city_id, :integer
    add_foreign_key :areas, :cities
  end
end
