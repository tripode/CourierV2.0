class Area < ActiveRecord::Base
  has_many :routing_sheets, :dependent => :destroy
  belongs_to :city
  validates :area_name,:city_id, :presence =>true
  
  def getAreas
    Area.all.collect{|a|[a.area_name, a.id]}
  end
end
