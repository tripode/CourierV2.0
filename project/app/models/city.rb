class City < ActiveRecord::Base
  has_many :receivers
  has_many :retire_notes
  has_many :transport_guides
  belongs_to :province
  has_many :cargo_manifests
  has_many :receiver_addresses
  has_many :areas


  #retorna una lista de todos las ciudades dentro de la BD
  def self.get_all_cities
    all.collect { |item|[item.name, item.id]  }
  end
  
end
