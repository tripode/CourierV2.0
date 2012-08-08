class ProductTypesController < ApplicationController
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
    authorize! :create, ProductType
  end
  
  # /Get new
  def new
    @product_type = ProductType.new
    @product_types = ProductType.all
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product_type }
    end
  end
  
  # /POST  create
  def create
    @product_type = ProductType.new(params[:product_type])
    respond_to do |format|
      if @product_type.save
        format.html { redirect_to new_product_type_path, notice: 'Se agrego el nuevo tipo de producto.' }
        format.json {  head :no_content }
      else
        format.html { redirect_to new_product_type_path, notice: 'No se guardo, por favor intente nuevamente' }
        format.json {  head :no_content }
      end
    end
  end
  # /POST delete
  def destroy
    @product_type = ProductType.find(params[:id])
    respond_to do |format|
      begin
      if @product_type.destroy
         CustomLogger.info("Se elimino el tipo de producto: #{@product_type.inspect}, usuario: #{current_user.username}, #{Time.now}")
        format.html { redirect_to new_product_type_path, notice: 'Se elimino el tipo de producto.' }
        format.json {  head :no_content }
      else
         CustomLogger.info("Este tipo de producto no puede ser eliminado: #{@product_type.inspect}, usuario: #{current_user.username}, #{Time.now}")
        format.html { redirect_to new_product_type_path, notice: 'Este tipo de producto no puede ser eliminado' }
        format.json {  head :no_content }
      end
      rescue
         CustomLogger.error("Este tipo de producto no puede ser eliminado: #{@product_type.inspect}, usuario: #{current_user.username}, #{Time.now}")
        format.html { redirect_to new_product_type_path, notice: 'Este tipo de producto no puede ser eliminado' }
        format.json {  head :no_content }
      end
    end
    
  end
end
