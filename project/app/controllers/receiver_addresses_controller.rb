class ReceiverAddressesController < ApplicationController
  # GET /receiver_addresses
  # GET /receiver_addresses.json
  def index
    @receiver_addresses = ReceiverAddress.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @receiver_addresses }
    end
  end

  # GET /receiver_addresses/1
  # GET /receiver_addresses/1.json
  def show
    @receiver_address = ReceiverAddress.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @receiver_address }
    end
  end

  # GET /receiver_addresses/new
  # GET /receiver_addresses/new.json
  def new
    @receiver_address = ReceiverAddress.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @receiver_address }
    end
  end

  # GET /receiver_addresses/1/edit
  def edit
    @receiver_address = ReceiverAddress.find(params[:id])
  end

  # POST /receiver_addresses
  # POST /receiver_addresses.json
  def create
    @receiver_address = ReceiverAddress.new(params[:receiver_address])

    respond_to do |format|
      if @receiver_address.save
        format.html { redirect_to @receiver_address, notice: 'Receiver address was successfully created.' }
        format.json { render json: @receiver_address, status: :created, location: @receiver_address }
      else
        format.html { render action: "new" }
        format.json { render json: @receiver_address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /receiver_addresses/1
  # PUT /receiver_addresses/1.json
  def update
    @receiver_address = ReceiverAddress.find(params[:id])

    respond_to do |format|
      if @receiver_address.update_attributes(params[:receiver_address])
        format.html { redirect_to @receiver_address, notice: 'Receiver address was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @receiver_address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receiver_addresses/1
  # DELETE /receiver_addresses/1.json
  def destroy
    @receiver_address = ReceiverAddress.find(params[:id])
    @receiver_address.destroy

    respond_to do |format|
      format.html { redirect_to receiver_addresses_url }
      format.json { head :no_content }
    end
  end
end
