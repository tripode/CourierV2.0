class AreasController < ApplicationController
  
   #
  # Antes de hacer cualquier cosa con este controler,
  # se verifica si hay permiso para el usuario logueado
  #
  before_filter :check_permissions
  skip_before_filter :require_no_authentication
  #
  # Llama a este metodo y verifica los permisos que tiene para Area
  #
  def check_permissions
    authorize! :create, Area
  end
  
  
  def index
    @areas = Area.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @areas}
    end
    
  end
  
  def new
    @areas = Area.all
    @area = Area.new
    @cities = City.all
     respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @area}
    end
  end
 
  
  def create
    @area = Area.new(params[:area])
    respond_to do |format|
      begin 
         @area.save
         @notice="La zona se registro correctamente."
         logger.info("Nueva zona creada por #{current_user.inspect}, #{Time.now}")
      rescue
         @notice="No se pudo registrar la zona."
         logger.error("Error al crear una zona. Usuario: #{current_user.inspect}, #{Time.now}")
      ensure
        format.html { redirect_to new_area_path, notice: @notice }
        format.json { head :no_content } 
      end
    end
  end
  
 
  
  def destroy
    @area_id= params[:id]
    @area= Area.find(@area_id)
    @notice=""
    respond_to do |format|
     begin
       @area.destroy
       @notice="La zona ha sido eliminada"
       logger.info("Zona #{@area.inspect} eliminada por #{current_user.inspect}, #{Time.now}")
     rescue
       @notice="Esta zona no puede ser eliminada"
       logger.error("Error al eliminar la zona: #{@area.inspect}, usuario: #{current_user.inspect}, #{Time.now}")
     ensure
       format.html { redirect_to new_area_path, notice: @notice }
       format.json { head :no_content } 
     end 
    end
    
  end
end
