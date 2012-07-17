class RoutingSheet < ActiveRecord::Base
  belongs_to :routing_sheet_state
  belongs_to :area
  belongs_to :employee
  
  validates :number, :area_id, :routing_sheet_state_id, :employee_id, :date, :total_amount, :presence =>true
  
  def format_admission_date
    admission_date=Date.today
    admission_date.strftime("%d-%m-%Y") if admission_date
  end
 
end
