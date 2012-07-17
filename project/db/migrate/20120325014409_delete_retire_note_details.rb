class DeleteRetireNoteDetails < ActiveRecord::Migration
  def up
    add_column :retire_notes, :product_type_id, :integer
    add_column :retire_notes, :city_id, :integer
    add_column :retire_notes, :amount, :integer
    add_column :retire_notes, :description, :string, :limit => 50
    add_column :retire_notes, :unit_price, :decimal
    drop_table :retire_note_details
  end

  def down
     
  end
end
