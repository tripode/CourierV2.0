class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :email, :limit => 60
        #  , :null => false     :null => false
      t.string :name, :limit => 30
      t.string :last_name, :limit => 30
      t.integer :num_identity
      t.string :address, :limit => 60
      t.date :admission_date
      t.date :birthday
      t.decimal :salary
      t.string :mobile_number, :limit => 20
      t.string :phone_number, :limit => 20
      t.integer :function_type_id  

    end
    add_foreign_key :employees, :function_types
  end
end
