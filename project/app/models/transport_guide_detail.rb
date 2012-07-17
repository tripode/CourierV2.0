class TransportGuideDetail < ActiveRecord::Base
#  self.primary_keys :id, :transport_guide_id
  belongs_to :transport_guide
  belongs_to :product_type

  #retorna una lista de los tipos de productos que estan en la
  #bd para un select
  def get_list_product_types
    ProductType.get_list_product_types_for_description
  end
end
