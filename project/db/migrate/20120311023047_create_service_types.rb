class CreateServiceTypes < ActiveRecord::Migration
  def change
    create_table :service_types do |t|
      t.integer :id
      t.string :description, :limits => 50, :null => false

    end
  end
end
