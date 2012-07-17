class CargoManifest < ActiveRecord::Base
  has_many :cargo_manifest_details
  belongs_to :city
  belongs_to :employee
  
  validates :manifest_num , :uniqueness =>true, :presence =>true
  validates :origin_city_id,:destiny_city_id , :presence =>true
  def format_date
    created_at=Date.today
    created_at.strftime("%d-%m-%Y") if created_at


  end
end
