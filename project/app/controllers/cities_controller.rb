require 'custom_logger'

class CitiesController < ApplicationController
 #
  # Antes de hacer cualquier cosa con este controler,
  # se verifica si hay permiso para el usuario logueado
  #
  before_filter :check_permissions
  skip_before_filter :require_no_authentication
  #
  # Llama a este metodo y verifica los permisos que tiene para City
  #
  def check_permissions
    authorize! :create, City
  end
  
  
  def index
    @cities = City.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cities}
    end
    
  end
  
  def new
    @cities = City.all
    @city = City.new
    @provinces= Province.all
    @countries = Country.all
     respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @city}
    end
  end
 
  
  def create
    @city = City.new(params[:city])
    respond_to do |format|
      begin 
         @city.save
         @notice="La ciudad se registro correctamente."
         CustomLogger.info("Se crea la ciudad: #{@city.inspect}, usuario: #{current_user.inspect}, #{Time.now}")
      rescue Exception => e
         @notice="No se pudo registrar la ciudad."
         CustomLogger.error("Error al crear la ciudad: #{@city.inspect}, usuario: #{current_user.inspect}, excepcion: #{e.inspect}, #{Time.now}")
      ensure
        format.html { redirect_to new_city_path, notice: @notice }
        format.json { head :no_content } 
      end
    end
  end
  
 
  
  def destroy
    @city_id= params[:id]
    @city= City.find(@city_id)
    @notice=""
    respond_to do |format|
     begin
       @city.destroy
       @notice="La ciudad ha sido eliminada"
       CustomLogger.info("Se borra la ciudad: #{@city.inspect}, usuario: #{current_user.inspect}, #{Time.now}")
     rescue Exception => e
       @notice="Esta ciudad no puede ser eliminada"
       CustomLogger.error("Error al borrar la ciudad: #{@city.inspect}, usuario: #{current_user.inspect}, #{Time.now}")
     ensure
       format.html { redirect_to new_city_path, notice: @notice }
       format.json { head :no_content } 
     end 
    end
  end
  
  def getCountry
    @province_id= params[:province_id]
    @province= Province.where("id=?",@province_id).first
    @country = Country.where("id=?", @province.country_id).first
    respond_to do |format|
      format.html # 
      format.json { render json: @country }
    end
  end
end
