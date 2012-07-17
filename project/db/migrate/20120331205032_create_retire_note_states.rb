class CreateRetireNoteStates < ActiveRecord::Migration
  def change
    create_table :retire_note_states do |t|
      t.integer :id
      t.string :state_name, :limit => 30
    end
  end
  add_column :retire_notes, :retire_note_state_id, :integer
 
end
