class Invoice < ActiveRecord::Base
  has_many :invoice_details
  belongs_to :customer
  
   #formato de fecha
  def format_date
    created_at= Date.today
    created_at.strftime("%d-%m-%Y") if created_at
  end
  
  #lista todos las formas de pagos disponibles en un select
  def get_list_payments_methods
    PaymentMethod.get_list_payment_methods
  end
end
