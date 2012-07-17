class AddRetireNoteNumberColumn < ActiveRecord::Migration
  def up
    add_column :retire_notes, :number, :integer
  end

  def down
  end
end
