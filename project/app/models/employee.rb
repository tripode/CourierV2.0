class Employee < ActiveRecord::Base
  belongs_to :function_type
  has_many :retire_notes
  has_many :transport_guides 
  has_many :users
  has_many :routing_sheets, :dependent => :destroy
  has_many :cargo_manifests

  validates :name, :last_name, :num_identity, :birthday,
    :mobile_number, :address,:function_type_id, :presence =>true
  
  
  
  def buscar_function_type
    FunctionType.all.collect{|tp|[tp.description, tp.id]}
  end
  

  def format_birthday
    birthday.strftime("%d-%m-%Y") if birthday
    
  end
  def format_admission_date
    admission_date=Date.today
    admission_date.strftime("%d-%m-%Y") if admission_date
    
    
  end
  
  #
  # This method returns a string with the full name of the employee
  #
  def full_name
    "#{self.name} #{self.last_name}"
  end
  
  #
  # This method returns a string with the full name of the employee
  # receive a length limit as 24 characters.
  #
  def full_name_24_length
    full = "#{self.name} #{self.last_name}"
    full[0,24]
  end
  #
  # This method returns a string with the full name of the employee
  # receive a length limit as parameter.
  #  
  def full_name_length(length)
    
    full = "#{self.name} #{self.last_name}"
    
    if full.length <= length.to_i
      full
    else
      full[0,length.to_i]+"..."
    end
  end  
    
end
