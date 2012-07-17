class CustomerType < ActiveRecord::Base
  attr_accessible :id, :type_name
  has_many :customers
end
