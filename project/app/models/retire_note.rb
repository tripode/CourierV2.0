class RetireNote < ActiveRecord::Base
  belongs_to :customer
  belongs_to :employee
  belongs_to :service_type
  belongs_to :city
  belongs_to :product_type
  belongs_to :retire_note_state
 
  has_many :products
  
  validates :number, :customer_id, :date, :expiration_date, :employee_id, :service_type_id, :product_type_id,
  :city_id, :amount, :unit_price, :retire_note_state_id, :presence => true
  
  def getTipoServicios
    ServiceType.all.collect{|tp|[tp.description, tp.id]}
  end
   def getClientes
    Customer.all.collect{|c|
      [if c.company_name.nil? then (c.last_name + " "+ c.name) else c.company_name end, c.id]}
  end
  def getTipoProductos
    ProductType.all.collect{|tp|[tp.description, tp.id]}
  end
  def getCiudades
    City.all.collect{|c|[c.name, c.id]}
  end
  def getFuncionarios
    Employee.all.collect{|e|[e.last_name + " " + e.name, e.id]}
  end
  def getEstados
    RetireNoteState.all.collect{|r|[r.state_name, r.id]}
  end
  #formato de fecha
  def format_date
    created_at= Date.today
    created_at.strftime("%d-%m-%Y") if created_at
  end
  
  
end
