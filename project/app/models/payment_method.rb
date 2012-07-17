class PaymentMethod < ActiveRecord::Base
  has_many :transport_guides

  #retorna una lita de formas de pagos almacenadas en la bd
  def self.get_list_payment_methods
    all.collect { |pm| [pm.name_payment, pm.id]  }
  end
end
