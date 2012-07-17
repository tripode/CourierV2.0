class ServiceType < ActiveRecord::Base
  has_many :retire_notes
  has_many :transport_guides

  def self.get_list_service_types
    all.collect{|type| [type.description, type.id]}
  end

end
