class InvoiceDetail < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :retire_note
end
