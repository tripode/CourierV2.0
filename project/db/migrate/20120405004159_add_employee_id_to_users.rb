class AddEmployeeIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :employee_id, :integer
    add_foreign_key :users, :employees
  end
end
