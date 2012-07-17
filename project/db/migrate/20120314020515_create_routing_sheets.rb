class CreateRoutingSheets < ActiveRecord::Migration
  def change
    create_table :routing_sheets do |t|
      t.integer :area_id, :null=>false
      t.integer :employee_id, :null=>false
      t.date :date
      t.integer :total_amount
      t.integer :routing_sheet_state_id, :null=>false

    end
    add_foreign_key :routing_sheets, :areas
    add_foreign_key :routing_sheets, :employees
    add_foreign_key :routing_sheets, :routing_sheet_states
  end
end
