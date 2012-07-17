class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.integer :id
      t.string :name, :limit => 60, :null =>false
      t.string :description, :limit => 60, :null => true
    end
  end
end
