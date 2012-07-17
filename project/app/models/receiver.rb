class Receiver < ActiveRecord::Base
  belongs_to :city
  has_many :products
  has_many :receiver_addresses, :dependent => :destroy
  
  accepts_nested_attributes_for :receiver_addresses
  
end
