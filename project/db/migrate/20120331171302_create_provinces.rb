class CreateProvinces < ActiveRecord::Migration
  def change
    create_table :provinces do |t|
      t.integer :id
      t.string :name,  :limit => 60, :null => false
      t.string :description, :limit => 60, :null => true
      t.integer :country_id

    end
    add_foreign_key :provinces, :countries
  end
end
