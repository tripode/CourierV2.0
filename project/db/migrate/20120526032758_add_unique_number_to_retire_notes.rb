class AddUniqueNumberToRetireNotes < ActiveRecord::Migration
  def change
    add_index :retire_notes, :number, :unique => true
  end
end
