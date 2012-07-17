class CreateCustomerTypes < ActiveRecord::Migration
  def change
    create_table :customer_types do |t|
      t.integer :id 
      t.string :type_name, :limit => 30
    end
  end
end
