class TransportGuideDetailsController < ApplicationController
  
  
  #
  # Antes de hacer cualquier cosa con este controler,
  # se verifica si hay permiso para el usuario logueado
  #
  before_filter :check_permissions
  skip_before_filter :require_no_authentication
  #
  # Llama a este metodo y verifica los permisos que tiene para Employee
  #
  def check_permissions
    authorize! :create, TransportGuideDetail
  end
  
  
  def index

  end
  def show
    
  end

  def new

  end

  def create

  end

  #delete
  def destroy

  end
  
 
  def method_aux
    @@transport_guide_details=nil
    @@entro=false
    respond_to do |format|
      format.js {redirect_to add_detail_product_transport_guide_details_path}
    end

  end

end
