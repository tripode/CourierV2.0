class AddCreatedDateToProducts < ActiveRecord::Migration
  def change
    add_column :products, :created_at, :date , :null => false
  end
end
