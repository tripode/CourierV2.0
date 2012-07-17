class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.integer :id
      t.string :name, :limit => 40
      t.string :last_name, :limit => 50
      t.string :company_name, :limit => 40 
      t.string :ruc, :limit => 10
      t.string :address, :limit => 100
      t.integer :num_identify
      t.string :mobile_number, :limit => 20
      t.string :phone_number, :limit => 20
      t.string :email, :limit => 60
      t.integer :customer_type_id
      
    end
       add_foreign_key :customers, :customer_types
  end
 
end
