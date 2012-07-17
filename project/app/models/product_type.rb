class ProductType < ActiveRecord::Base
 
  has_many :products
  has_many :transport_guide_details#, :foreign_key => [:id, :transport_guide_id]
  has_many :retire_notes


#  lista todo los tipos de productos por description
  def self.get_list_product_types_for_description
    all.collect { |pt| pt.description  }
  end

  #  lista todo los tipos de productos
  def self.get_list_product_types
    all.collect { |pt| [pt.description,pt.id]  }
  end

end
