class CreateRetireNotes < ActiveRecord::Migration
  def change
    create_table :retire_notes do |t|
      t.integer :id
      t.integer :employee_id
      t.date :date
      t.integer :service_type_id
      t.integer :customer_id
    end
     add_foreign_key :retire_notes, :customers
     add_foreign_key :retire_notes, :employees
     add_foreign_key :retire_notes, :service_types
     
  end
end
