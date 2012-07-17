class Reason < ActiveRecord::Base
  has_many :routing_sheet_details
  
  def self.getReasons
    all.collect { |pt| [pt.description, pt.id]  }
  end
end
