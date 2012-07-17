class FunctionType < ActiveRecord::Base

  has_many :employees
  def self.getListaFunc
    all.collect{|tp| tp.description}
  end
end
