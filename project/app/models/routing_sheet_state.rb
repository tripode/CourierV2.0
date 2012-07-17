class RoutingSheetState < ActiveRecord::Base
  has_many :routing_sheets, :dependent =>:destroy
  
  def getRoutingSheetStates
    RoutingSheetState.all.collect{|rs|[rs.state_name, rs.id]}
  end
end
