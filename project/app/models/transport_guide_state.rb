class TransportGuideState < ActiveRecord::Base
  has_many :transport_guides
  #metodo par a listar las Estado de guia
  #de tranporte en select
  def self.get_list_guide_state
    all.collect{|tp| [tp.name_state, tp.id]}
  end
  def self.procesado
    TransportGuideState.find_by_name_state('Procesado').id.to_i
  end
end
