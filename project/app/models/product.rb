class Product < ActiveRecord::Base
  belongs_to :product_type
  belongs_to :retire_note
  belongs_to :product_state
  belongs_to :receiver
  belongs_to :receiver_address
  has_many :routing_sheet_details
  
   validates :retire_note_id, :receiver_id, :remitter, :product_type_id,
    :product_state_id,:bar_code,:created_at, :presence =>true
    
  def format_admission_date
    admission_date=Date.today
    admission_date.strftime("%d-%m-%Y") if admission_date
  end
  
  def months
    months = {
      'Enero' => 1, 'Febrero' => 2, 'Marzo' => 3, 'Abril' => 4,
      'Mayo' => 5,  'Junio' => 6, 'Julio' => 7, 'Agosto' => 8,
      'Septiembre' => 9, 'Octubre' => 10, 'Noviembre' => 11, 'Diciembre' => 12}
  end
  
end
