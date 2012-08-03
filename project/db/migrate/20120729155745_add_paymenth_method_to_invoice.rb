class AddPaymenthMethodToInvoice < ActiveRecord::Migration
  def change
    add_foreign_key :invoices, :payment_methods
  end
end
