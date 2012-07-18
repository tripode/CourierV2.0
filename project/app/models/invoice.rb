class Invoice < ActiveRecord::Base
  has_many :invoice_details
  belong_to :customer
end
