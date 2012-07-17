class TransportGuidesController < ApplicationController
  
  
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
    authorize! :create, TransportGuide
  end
  
  
  # GET /transport_guides
  # GET /transport_guides.json
  def index
    #    @transport_guides = TransportGuide.find(:all, :conditions=> "created_at between current_date-10 and current_date")
    @transport_guides= TransportGuide.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @transport_guides }
    end
  end

  # GET /transport_guides/1
  # GET /transport_guides/1.json
  def show
    @transport_guide = TransportGuide.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transport_guide }
    end
  end

  # GET /transport_guides/new
  # GET /transport_guides/new.json
  def new
    @@cities = City.find(:all)
    @cities = @@cities
    @@customers = Customer.find(:all)
    @customers = @@customers;
    @transport_guide = TransportGuide.new
    @transport_guide_detail=TransportGuideDetail.new
    #    @transport_guide_details = TransportGuideDetail.where(transport_guide_id: @transport_guide.id)
    #mala practica de programación pero lo hago para el metodo js agregarFila_Arreglo
    #no me tire error en el each vere como puedo depurar luego
    @transport_guide_details= TransportGuideDetail.where(transport_guide_id: 0)
    @hide_state = true
    @@transport_guide_details= nil
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transport_guide }
    end
  end

  # GET /transport_guides/1/edit
  def edit

    @cities = City.find(:all)
    @customers = Customer.find(:all)
    @transport_guide_detail=TransportGuideDetail.new
    
    @transport_guide = TransportGuide.find(params[:id])
    @transport_guide_details = TransportGuideDetail.where(transport_guide_id: @transport_guide.id)
    @@transport_guide_details=@transport_guide_details.to_set
    @hide_state = false
    unless (@transport_guide.transport_guide_state.name_state== 'Procesado')
      respond_to do |format|
        format.html { render action: "new" }
        #        format.js
        format.json { render json: @transport_guide }
      end
    else
      @transport_guide_states= TransportGuideState.all.collect { |item| [item.name_state,item.id] }
      @transport_guides= TransportGuide.where(id: 0)
      respond_to do |format|
        format.html { redirect_to tg_searching_transport_guides_path, notice: "No se puede editar Guias de Transportes cuyo estado sea 'Procesado'" }
        format.json { head :no_content }
      end
    end
    
  end

  # POST /transport_guides
  # POST /transport_guides.json
  def create
    begin
      TransportGuide.transaction do

        @transport_guide = TransportGuide.new(params[:transport_guide])
        @transport_guide.transport_guide_state_id= TransportGuideState.find_by_name_state('En Proceso').id
        @transport_guide.save
        params[:details].each do |k,v|
          v[:transport_guide_id] =@transport_guide.id
          @transport_guide_detail =TransportGuideDetail.new(v)
          @transport_guide_detail.save

        end
      end
      respond_to do |format|
        format.html { redirect_to new_transport_guide_path, notice: "Guardado Correctamente!"}
        format.json { head :no_content}
      end
    rescue ActiveRecord::StatementInvalid
      manejo_error_pg(@transport_guide)
    rescue
      respond_to do |format|
        format.html { redirect_to new_transport_guide_path,
          notice: "Error en la transaccion, no se guardo la Guia de Transporte. Verifique que halla ingresado algun Producto"}
        format.json { head :no_content}
      end

    end
    
  end


  # PUT /transport_guides/1
  # PUT /transport_guides/1.json
  def update
    @transport_guide = TransportGuide.find(params[:id])
    
    begin
      if (@transport_guide.transport_guide_state.name_state== 'Procesado')
        raice "No se puede editar Guias de Transportes cuyo estado anterior sea 'Procesado'"
      end
      TransportGuide.transaction do
        @transport_guide.update_attributes(params[:transport_guide])
        @transport_guide_details=TransportGuideDetail.where(transport_guide_id: @transport_guide.id)
        @transport_guide_details.each do |item|
          item.delete
        end
        unless(params[:details].nil?)
          params[:details].each do |k,v|
            v[:transport_guide_id] =@transport_guide.id
            @transport_guide_detail =TransportGuideDetail.new(v)
            @transport_guide_detail.save
          end         
        end
        
      end
      respond_to do |format|
        format.html { redirect_to new_transport_guide_path, notice: "GT# #{@transport_guide.num_guide} Actualizado Correctamente!"}
        format.json { head :no_content}
      end
    rescue ActiveRecord::StatementInvalid
      manejo_error_pg(@transport_guide)
    rescue Exception => e
      respond_to do |format|
        format.html { redirect_to new_transport_guide_path, notice: e}
        format.json { render json: @transport_guide.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transport_guides/1
  # DELETE /transport_guides/1.json
  def destroy
    attr= TransportGuideState.find_by_name_state('En Proceso').id
    @transport_guide = TransportGuide.find(params[:id])
    num= @transport_guide.num_guide
    @transport_guide.update_attributes('transport_guide_state_id', attr)
    
    respond_to do |format|
      format.html { redirect_to tg_searching_transport_guides_path, notice: "La Guia de Transporte #{num} ha sido cancelada" }
      format.json { head :no_content }
    end
  end

  #get
  def tg_searching

    @transport_guide_states= TransportGuideState.all.collect { |item| [item.name_state,item.id] }
    @customers= Customer.find(:all)
    @cities= City.find(:all)
    @transport_guides= TransportGuide.where(id: 0)
    respond_to do |format|
      format.html
      format.json { head :no_content }
    end

  end
  #get
  def get_list_tg
    @consult= Hash.new
    @customers= Customer.find(:all)
    @cities= City.find(:all)
    @transport_guide_states= TransportGuideState.all.collect { |item| [item.name_state,item.id] }
    
    params[:search].each do |k,v|
      if(v!="")
        @consult[k]=v
      end
    end
    date_from = params[:date_range][:date_from]
    date_to = params[:date_range][:date_to]
    if( date_from != "" || date_to !="")
      @consult[:created_at]=date_from..date_to
    end
    puts @consult.to_s
    begin
      @transport_guides=TransportGuide.where(@consult)
      respond_to do |format|
        format.js
      end
    rescue
      @transport_guides=TransportGuide.where(id: 0)
      respond_to do |format|
        format.js
      end
    end
    
    


  end

  #post
  def delete_detail_product
    cont = 0
    tgd=Set.new
    unless(@@transport_guide_details.nil?)
      tgd=@@transport_guide_details       
      @@transport_guide_details=Set.new
      tgd.each do |detail|
        if(params[:destroy].to_i!= cont)
          puts detail.product_type.description
          @@transport_guide_details.add(detail)
        end

        cont+=1
      end
      @transport_guide_details=@@transport_guide_details
      respond_to do |format|
        format.js
      end
    else
      raice 'ERROR critico'
    end
  end

  #post

  def add_detail_product
    @transport_guide_detail=TransportGuideDetail.new
    @transport_guide_detail.amount=params[:amount]
    @transport_guide_detail.weight=params[:weight]
    @transport_guide_detail.unit_cost=params[:unit_cost]
    @transport_guide_detail.product_type_id=params[:product_type_id]
    if(@transport_guide_detail.product_type_id!=nil)
      @@transport_guide_details=Set.new if @@transport_guide_details.nil?
      @@transport_guide_details.add(@transport_guide_detail)
    end
    @transport_guide_details=@@transport_guide_details
    respond_to do |format|
      format.js
    end

  end
  
  private
  def manejo_error_pg(transport_guide)
    transport_guide.num_guide=''
    @tranport_guide=transport_guide
    @cities = @@cities
    @customers = @@customers
    @transport_guide_detail=TransportGuideDetail.new
    @transport_guide_details = TransportGuideDetail.where(transport_guide_id: 0)
    respond_to do |format| 
      format.html { redirect_to new_transport_guide_path,
        notice: "ERROR, Numero de Guia de Transporte ingresado ya existe"}
      format.json { head :no_content }
    end
  end


end
