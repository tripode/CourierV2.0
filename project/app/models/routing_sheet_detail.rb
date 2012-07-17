class RoutingSheetDetail < ActiveRecord::Base
  belongs_to :product
  belongs_to :reason
  
  validates :routing_sheet_id, :product_id, :presence => true
end
