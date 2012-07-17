class AddRetireNoteStateId < ActiveRecord::Migration
  def up
     add_foreign_key :retire_notes, :retire_note_states
    remove_column :retire_notes, :state
  end

  def down
  end
end
