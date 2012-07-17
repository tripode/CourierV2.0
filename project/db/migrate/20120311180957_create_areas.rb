class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :area_name, :limit=>50 , :null=>false
      t.string :description, :limit=>100

    end
  end
end
