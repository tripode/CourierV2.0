class AddKeysInvoiceDetail < ActiveRecord::Migration
  def up
    add_foreign_key :invoice_details, :retire_notes
    add_foreign_key :invoice_details, :invoices
  end

  def down
  end
end
