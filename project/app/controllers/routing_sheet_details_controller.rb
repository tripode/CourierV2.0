class RoutingSheetDetailsController < ApplicationController
  
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
    authorize! :create, RoutingSheetDetail
  end
    
  
  # GET /routing_sheet_details
  # GET /routing_sheet_details.json
  def index
    @routing_sheet_details = RoutingSheetDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @routing_sheet_details }
    end
  end

  # GET /routing_sheet_details/1
  # GET /routing_sheet_details/1.json
  def show
    @routing_sheet_detail = RoutingSheetDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @routing_sheet_detail }
    end
  end

  # GET /routing_sheet_details/new
  # GET /routing_sheet_details/new.json
  def new
    @routing_sheet_detail = RoutingSheetDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @routing_sheet_detail }
    end
  end

  # GET /routing_sheet_details/1/edit
  def edit
    @routing_sheet_detail = RoutingSheetDetail.find(params[:id])
  end

  # POST /routing_sheet_details
  # POST /routing_sheet_details.json
  def create
    @routing_sheet_detail = RoutingSheetDetail.new(params[:routing_sheet_detail])

    respond_to do |format|
      if @routing_sheet_detail.save
        format.html { redirect_to @routing_sheet_detail, notice: 'Routing sheet detail was successfully created.' }
        format.json { render json: @routing_sheet_detail, status: :created, location: @routing_sheet_detail }
      else
        format.html { render action: "new" }
        format.json { render json: @routing_sheet_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /routing_sheet_details/1
  # PUT /routing_sheet_details/1.json
  def update
    @routing_sheet_detail = RoutingSheetDetail.find(params[:id])

    respond_to do |format|
      if @routing_sheet_detail.update_attributes(params[:routing_sheet_detail])
        format.html { redirect_to @routing_sheet_detail, notice: 'Routing sheet detail was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @routing_sheet_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /routing_sheet_details/1
  # DELETE /routing_sheet_details/1.json
  def destroy
    @routing_sheet_detail = RoutingSheetDetail.find(params[:id])
    @routing_sheet_detail.destroy

    respond_to do |format|
      format.html { redirect_to routing_sheet_details_url }
      format.json { head :no_content }
    end
  end
end
