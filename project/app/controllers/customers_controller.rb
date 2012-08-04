require 'custom_logger'

class CustomersController < ApplicationController
  
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
    authorize! :create, Customer
  end
  
  
  # GET /customers
  # GET /customers.json
  def index
    @customers = Customer.find(:all, :conditions => "customer_type_id = 2")
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @customers }
    end
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    @customer = Customer.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @customer }
    end
  end 

  # GET /customers/new
  # GET /customers/new.json
  def new
    @customer = Customer.new
    @customer_types = Customer.find(:all, :conditions => "customer_type_id = 2")
    @customers = Customer.find(:all, :conditions => "customer_type_id = 2")

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @customer }
    end
  end

  # GET /customers/1/edit
  def edit
    @customer = Customer.find(params[:id])
    @customer_types = CustomerType.all
    respond_to do |format|
      format.js
    end
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(params[:customer])
    @customer.customer_type_id = CustomerType.where("type_name='Persona' ").first.id
    @customer.company_name='' #se guarda un espacio
    @notice=""
    respond_to do |format|
      begin 
         @customer.save
         @notice="El cliente se registro correctamente."
         CustomLogger.info("Se crea cliente persona: #{@customer}, usuario: #{current_user.username}, #{Time.now}")
      rescue
         @notice="No se pudo registrar el cliente."
         CustomLogger.error("Error al crear cliente persona: #{@customer}, usuario: #{current_user.username}, #{Time.now}")
      ensure
        format.html { redirect_to new_customer_path, notice: @notice }
        format.json { head :no_content } 
      end
    end
  end

  # PUT /customers/1
  # PUT /customers/1.json
  def update
    @customer = Customer.find(params[:id])
    @notice=""
    respond_to do |format|
      begin 
         @customer.update_attributes(params[:customer])
         @notice="El cliente se actualizo correctamente."
         CustomLogger.info("Se actualiza cliente persona: #{@customer}, usuario: #{current_user.username}, #{Time.now}")
      rescue
         @notice="No se pudo actualizar el cliente."
         CustomLogger.error("Error al actualizar cliente persona: #{@customer}, usuario: #{current_user.username}, #{Time.now}")
      ensure
        format.html { redirect_to new_customer_path, notice:@notice }
        format.json { head :no_content } 
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer = Customer.find(params[:id])
    @notice=""
    respond_to do |format|  
      begin
        @customer.destroy
        @notice="El cliente ha sido eliminado."
        CustomLogger.info("Se elimina cliente persona: #{@customer}, usuario: #{current_user.username}, #{Time.now}")
      rescue
        @notice="Este cliente no puede ser eliminado."
        CustomLogger.error("Error al eliminar cliente persona: #{@customer}, usuario: #{current_user.username}, #{Time.now}")
      ensure
        format.html { redirect_to new_customer_path,  notice: @notice }
        format.json { head :no_content }
      end
    end
  end
  
   
end
