class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.integer :id
      t.string :name, :limit => 50, :null => false
      t.string :department, :limit => 50, :null => false


    end
  end
end
