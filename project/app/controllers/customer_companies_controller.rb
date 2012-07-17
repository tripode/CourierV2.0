class CustomerCompaniesController < ApplicationController
  
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
  
  
  # GET /customer_companies
  # GET /customer_companies.json
  def index
    @customer_companies = Customer.find(:all, :conditions => "customer_type_id = 1")
   
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @customer_companies }
    end
  end

  # GET /customer_companies/1
  # GET /customer_companies/1.json
  def show
    @customer_company = Customer.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @customer_company }
    end
  end

  # GET /customer_companies/new
  # GET /customer_companies/new.json
  def new
    @customer_company = Customer.new
    @customer_companies = Customer.find(:all, :conditions => "customer_type_id = 1") # 1=cliente empresa
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @customer_company }
    end
  end

  # GET /customer_companies/1/edit
  def edit
    @customer_company = Customer.find(params[:id])
    @customer_types = CustomerType.all
    respond_to do |format|
      # format.html { render action: "index" }
       format.js 
      # format.json { render json: @customer_company }
    end
  end

  # POST /customer_companies
  # POST /customer_companies.json
  def create
    @customer_company = Customer.new(params[:customer])
    @customer_company.customer_type_id =CustomerType.where("type_name='Empresa' ").first.id
    @customer_company.name=''
    @customer_company.last_name=''
    @notice=""
    respond_to do |format|
      begin 
         @customer_company.save
         @notice="El cliente se registro correctamente."
         logger.info("Se crea una empresa cliente: #{@customer_company.inspect}, usuario: #{current_user.username}, #{Time.now}")
      rescue
         @notice="No se pudo registrar el cliente."
         logger.error("Error al crear una empresa cliente: #{@customer_company.inspect}, usuario: #{current_user.username}, #{Time.now}")
      ensure
        format.html { redirect_to new_customer_company_path, notice: @notice }
        format.json { head :no_content } 
      end
    end
  end

  # PUT /customer_companies/1
  # PUT /customer_companies/1.json
  def update
    @customer_company = Customer.find(params[:id])
    respond_to do |format|
      begin 
        @customer_company.update_attributes(params[:customer])
         @notice="El cliente se actualizo correctamente."
         logger.info("Se actualiza empresa cliente: #{@customer_company.inspect}, usuario: #{current_user.username}, #{Time.now}")
      rescue
         @notice="No se pudo actualizar el cliente."
         logger.error("Error al actualizar empresa cliente: #{@customer_company.inspect}, usuario: #{current_user.username}, #{Time.now}")
      ensure
        format.html { redirect_to new_customer_company_path, notice: @notice }
        format.json { head :no_content } 
      end
    end
  end

  # DELETE /customer_companies/1
  # DELETE /customer_companies/1.json
  def destroy
    @customer_company = Customer.find(params[:id])
    @notice=""

    respond_to do |format|
      begin
        @customer_company.destroy
        @notice="El cliente ha sido eliminado."
        logger.info("Se elimina cliente empresa: #{@customer_company}, usuario: #{current_user.username}, #{Time.now}")
      rescue
        @notice="Este cliente no puede ser eliminado."
        logger.error("Error al eliminar cliente empresa: #{@customer_company}, usuario: #{current_user.username}, #{Time.now}")
      ensure
        format.html { redirect_to new_customer_company_path,notice: @notice }
        format.json { head :no_content }
      end
    end
  end
end

