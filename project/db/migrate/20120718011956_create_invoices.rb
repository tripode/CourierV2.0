class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :id
      t.datetime :date
      t.integer :customer_id
      t.decimal :total
      t.string :number
      t.integer :payment_method_id
      t.decimal :iva5
      t.decimal :iva10
      t.string :invoice_state
    end
  end
end
