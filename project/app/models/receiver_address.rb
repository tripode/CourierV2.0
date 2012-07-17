class ReceiverAddress < ActiveRecord::Base
  belongs_to :city
  belongs_to :receiver
  has_many :products
  
  validates :address, presence:true
  validates_length_of :label, :maximum => 40

  
end
