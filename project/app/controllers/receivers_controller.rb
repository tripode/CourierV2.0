class ReceiversController < ApplicationController
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
    authorize! :create, Receiver
  end
  
  # GET /receivers
  # GET /receivers.json
  def index
    @receivers = Receiver.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @receivers }
    end
  end

  # GET /receivers/1
  # GET /receivers/1.json
  def show
    @receiver = Receiver.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @receiver }
    end
  end

  # GET /receivers/new
  # GET /receivers/new.json
  def new
    if(params[:messages])
      @messages = params[:messages]
    end
    @receiver = Receiver.new
    @receivers = Receiver.order('created_at DESC').limit 10
    @cities = City.all
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @receiver }
    end
  end

  # GET /receivers/1/edit
  def edit
    @receiver = Receiver.find(params[:id])
    @cities = City.all
    respond_to do |format|
      format.js
    end
  end

  # POST /receivers
  # POST /receivers.json
  def create
    error = false
    parameters = true
    if params[:receiver] && 
       params[:receiver][:receiver_addresses_attributes] && 
      (params[:receiver][:receiver_addresses_attributes].size > 0)
      begin
        Receiver.transaction do
          @receiver = Receiver.create(:receiver_name => params[:receiver][:receiver_name],
                                   :document => params[:receiver][:document])

          @receiver_addresses = params[:receiver][:receiver_addresses_attributes]
          @receiver_addresses.each do |address|
            ReceiverAddress.create(:receiver_id => @receiver.id, 
                                   :label => address[1][:label],
                                   :address => address[1][:address],
                                   :city_id => address[1][:city_id])  
          end
        end
        @messages = {:success => "El destinatario se guardo destinatario"}
      rescue
        @messages = {:error => "No se pudo guardar el destinatario"}
        error = true
      end
    else
      @messages = {:alert => "No se pudo guardar el destinatario. Debe tener al menos una direccion. Por favor, verifique los campos ingresados."}
      parameters = false
    end
    
    
    respond_to do |format|
      if (error and parameters) or (!error and !parameters)
          @receivers = Receiver.order('created_at DESC').limit 10
          @cities = City.all
          format.html { render :action => :new }
          format.json { render json: @receiver, status: :created, location: @receiver }
      else
          format.html { redirect_to new_receiver_path, :messages => {:success => 'El destinatario se guardo correctamente.'}}
          format.json { head :no_content }
      end
    end
  end

  # PUT /receivers/1
  # PUT /receivers/1.json
  def update
    @receiver = Receiver.find(params[:id])
    respond_to do |format|
      if @receiver.update_attributes(params[:receiver])
        @messages = {:success => "El destinatario se ha actualizado correctamente"}
        format.html { redirect_to new_receiver_path, notice: 'Receiver was successfully updated.' }
        format.json { head :no_content }
      else
        @messages = {:success => "El destinatario no se ha actualizado, por favor, verifique los datos ingresados"}
        format.html { render action: "edit" }
        format.json { render json: @receiver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receivers/1
  # DELETE /receivers/1.json
  def destroy
    @receiver = Receiver.find(params[:id])
    error = false
    begin
      @receiver.destroy
      @messages = {:success => "El destinatario se ha eliminado correctamente"}
    rescue
      @messages = {:error => "No se pudo eliminar el destinatario"}
      error = true
    end

    respond_to do |format|
      if !error
          format.html { redirect_to new_receiver_url }
          format.json { head :no_content }
      else
        @receiver = Receiver.new
        @receivers = Receiver.order('created_at DESC').limit 10
        @cities = City.all
        format.html { render :action => :new}
          format.json { head :no_content }
      end
    end
  end
  
  ##
  # This method get a ReceiveAddress and put
  # it in a hash of an existing instance of @receiver
  #
  def add_address
    
    params[:place]
    address = ReceiverAddress.new(:label    => params[:place], 
                                  :city_id  => params[:city_id], 
                                  :address  => params[:address])
    @receive.document = "234"
    @receiver.receiver_addresses << address
    respond_to do |format|
      format.html { render @receiver, action ='new'}
    end
  end
end
