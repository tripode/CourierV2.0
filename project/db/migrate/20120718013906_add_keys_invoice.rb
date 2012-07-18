class AddKeysInvoice < ActiveRecord::Migration
  def up
    add_foreign_key :invoices, :customers
    
  end

  def down
  end
end
