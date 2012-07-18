class CreateInvoiceDetails < ActiveRecord::Migration
  def change
    create_table :invoice_details do |t|
      t.integer :id
      t.integer :invoice_id
      t.integer :retire_note_id
      t.integer :sub_total
    end
  end
end
