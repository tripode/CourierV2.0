class AddForeignerKeyToRetireNotes < ActiveRecord::Migration
  def change
    add_foreign_key :retire_notes, :product_types
    add_foreign_key :retire_notes, :cities
  end
end
