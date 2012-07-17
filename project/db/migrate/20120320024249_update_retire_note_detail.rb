class UpdateRetireNoteDetail < ActiveRecord::Migration
  def up
    add_column :retire_note_details, :city_id, :integer
    add_column :retire_note_details, :unit_price, :decimal
    add_column :retire_note_details, :description, :string
  end

  def down
  end
end
