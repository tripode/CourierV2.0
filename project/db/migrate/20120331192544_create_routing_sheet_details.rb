class CreateRoutingSheetDetails < ActiveRecord::Migration
  def change
    create_table :routing_sheet_details do |t|
      t.integer :id
      t.integer :routing_sheet_id
      t.integer :product_id
      t.string :who_received, :limit => 40
      t.string :comentary, :limit => 50
      t.integer :reason_id

    end
    add_foreign_key :routing_sheet_details , :products
    add_foreign_key :routing_sheet_details , :routing_sheets
    add_foreign_key :routing_sheet_details , :reasons
  end
end
