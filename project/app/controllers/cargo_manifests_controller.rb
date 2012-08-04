require 'custom_logger'

class CargoManifestsController < ApplicationController
  
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
    authorize! :create, CargoManifest
  end
  
  # GET /cargo_manifests
  # GET /cargo_manifests.json
  def index
    @cargo_manifests = CargoManifest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cargo_manifests }
    end
  end

  # GET /cargo_manifests/1
  # GET /cargo_manifests/1.json
  def show
    @cargo_manifest = CargoManifest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cargo_manifest }
    end
  end

  # se setean todos los valores necesarios para levantar la ventana new
  # de Manifiesto de carga
  # GET /cargo_manifests/new
  # GET /cargo_manifests/new.json
  def new
    #   .find(:all, :conditions => "customer_type_id = 1") Customer.find(:all, :conditions => "customer_type_id = 1")
    last_cargo_manifest = CargoManifest.find(:last)
    if last_cargo_manifest.nil?
      c_m=0
    else
      c_m=last_cargo_manifest.manifest_num
    end
    @cargo_manifest = CargoManifest.new
    @cargo_manifest.manifest_num =c_m.to_i + 1
    @transport_guides= TransportGuide.where(id: 0)
    @cargo_manifest_detail=CargoManifestDetail.new
    #    @transport_guide_details= TransportGuideDetail.all
    @cities= City.find(:all)
    @btt_guardar='Guardar'
    @option_print=false

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cargo_manifest}
    end
  end

  # GET /cargo_manifests/1/edit
  def edit
    @cargo_manifest = CargoManifest.find(params[:id])
    @cargo_manifest_detail=CargoManifestDetail.where(cargo_manifest_id: @cargo_manifest.id)
    @transport_guides= Set.new
    @cargo_manifest_detail.each do |cmd|
      transport_guides=TransportGuide.find(cmd.transport_guide_id)
      @transport_guides.add(transport_guides)
    end
  
    #    @transport_guides=TransportGuide.where(origin_city_id: @cargo_manifest.origin_city_id,
    #      destination_city_id: @cargo_manifest.destiny_city_id,
    #      transport_guide_state_id: TransportGuideState.find_by_name_state('Procesado').id )
    @@transport_guides=@transport_guides
    @cargo_manifest_detail=CargoManifestDetail.new
    #    @transport_guide_details= TransportGuideDetail.all
    @cities= City.find(:all)
    @btt_guardar='Actualizar'
    @option_print=true
    respond_to do |format|
      format.html { render action: "new" }
      format.json { render json: @transport_guide }
    end
  end

  # POST /cargo_manifests
  # POST /cargo_manifests.json
  # prepara los datos que se ingresan en la interfaz de Crear Manifiesto de Carga
  # para guardalos en la BD.
  #
  def create
    begin

      @cargo_manifest = CargoManifest.new(params[:cargo_manifest])
      CargoManifest.transaction do
        @cargo_manifest.manifest_num= params[:cargo_manifest][:manifest_num]
        @cargo_manifest.total_weight=params[:data][:total_weight]
        @cargo_manifest.total_products=params[:data][:total_products]
        @cargo_manifest.total_guides=params[:data][:total_guides]

        @cargo_manifest.origin_city_id=@@origin
        @cargo_manifest.destiny_city_id=@@destiny
        @cargo_manifest.save
        CustomLogger.info("Se creo manifiesto de carga: #{@cargo_manifest.inspect}, usuario: #{current_user.inspect}, #{Time.now}")
        #se cree el detalle
        cargo_manifest_details= params[:transport_guides_list]
        unless(cargo_manifest_details.nil?)
          cargo_manifest_details.each do |k,v|
            cargo_manifest_detail = CargoManifestDetail.new
            cargo_manifest_detail.cargo_manifest_id=@cargo_manifest.id
            cargo_manifest_detail.transport_guide_id=v.to_i
            transport_guide = TransportGuide.find(v.to_i)
            transport_guide.update_attribute('transport_guide_state_id', TransportGuideState.find_by_name_state('Procesado').id )
            cargo_manifest_detail.save
          end
        end
      end
        cargo_manifest = CargoManifest.find(@cargo_manifest.id);
        respond_to do |format|
          format.html do
            create_date=Date.today.strftime("%d-%m-%Y")
            @file_path = "#{Rails.root}/app/views/reports/manifests/manifiesto_carga_#{cargo_manifest.manifest_num}_#{create_date}.pdf"
            employee= Employee.find(cargo_manifest.employee_id)
            pdf = CargoManifestReportPdf.new(create_date,employee,cargo_manifest)#,new_cargo_manifest_url, root_url, @file_path)
            begin
              pdf.render_file(@file_path, flash[:notice]= "Guardado Correctamente")
           
            rescue
              #no se guardo el archivo
            end
            send_data pdf.render, filename: "manifiesto_carga_#{cargo_manifest.manifest_num}_#{create_date}.pdf",
             type: "application/pdf",
              disposition: "inline"
            
#            redirect_to new_cargo_manifest_path, notice: "Guardado  Correctamente y se genero Correctamente el PDF!"
          end
        end
    rescue ActiveRecord::StatementInvalid
      CustomLogger.error("Error al crear manifiesto de carga: #{@cargo_manifest.inspect}, usuario: #{current_user.inspect}, #{Time.now}")
      manejo_error_pg(@cargo_manifest)
    rescue
      CustomLogger.error("Error al crear manifiesto de carga: #{@cargo_manifest.inspect}, usuario: #{current_user.inspect}, #{Time.now}")
      respond_to do |format|
        format.html { redirect_to new_cargo_manifest_path,notice: "Error al guardar!"}
        format.json { render json: @cargo_manifest.errors, status: :unprocessable_entity }
      end
    
    end
  
  end

  # PUT /cargo_manifests/1
  # PUT /cargo_manifests/1.json
  def update
    begin
      @cargo_manifest = CargoManifest.find(params[:id])
      CargoManifest.transaction do
        # MEJORAR!
        @cargo_manifest.update_attribute('manifest_num', params[:cargo_manifest][:manifest_num].to_i)
        @cargo_manifest.update_attribute('total_weight', params[:data][:total_weight])
        @cargo_manifest.update_attribute('total_products', params[:data][:total_products])
        @cargo_manifest.update_attribute('total_guides', params[:data][:total_guides])
        #se crea el detalle
        old_cargo_manifest_details= CargoManifestDetail.where(cargo_manifest_id: @cargo_manifest.id)
        old_cargo_manifest_details.each do |e|
          e.transport_guide.update_attribute('transport_guide_state_id', TransportGuideState.find_by_name_state('En Proceso').id)
          e.destroy
        end
        cargo_manifest_details= params[:transport_guides_list]
        cargo_manifest_details.each do |k,v|
          cargo_manifest_detail = CargoManifestDetail.new
          cargo_manifest_detail.cargo_manifest_id=@cargo_manifest.id
          cargo_manifest_detail.transport_guide_id=v.to_i
          transport_guide = TransportGuide.find(v.to_i)
          transport_guide.update_attribute('transport_guide_state_id', TransportGuideState.find_by_name_state('Procesado').id )
          cargo_manifest_detail.save
        end

      end
      respond_to do |format|
        format.html { redirect_to new_cargo_manifest_path, notice: "Actualizado Correctamente!"}
        format.json { head :no_content}
      end

    rescue ActiveRecord::StatementInvalid
      CustomLogger.error("Error al actualizar manifiesto de carga: #{@cargo_manifest.inspect}, usuario: #{current_user.inspect}, #{Time.now}")
      manejo_error_pg(@cargo_manifest)

    rescue
      respond_to do |format|
        format.html { redirect_to new_cargo_manifest_path, notice: "Error en al actualizar el manifiesto de carga!"}
        format.json { head :no_content}
      end
      
    end
    
  end

  # DELETE /cargo_manifests/1
  # DELETE /cargo_manifests/1.json
  def destroy
    @cargo_manifest = CargoManifest.find(params[:id])
    num = @cargo_manifest.manifest_num
    attr= TransportGuideState.find_by_name_state('En Proceso').id
    CargoManifest.transaction do
      @cargo_manifest.cargo_manifest_details.each do |detail|
        tg=detail.transport_guide
        tg.update_attribute('transport_guide_state_id', attr)
        detail.delete
      end
      @cargo_manifest.delete
      CustomLogger.info("Se borra manifiesto de carga: #{@cargo_manifest.inspect}, usuario: #{current_user.inspect}, #{Time.now}")
    end
    

    respond_to do |format|
      format.html { redirect_to cargo_manifests_url, notice: "El Manifiesto de cargo #{num} ha sido borrado"}
      format.json { head :no_content }
    end
  end

  #POST . Peticion AJAX
  #
  #Metodo utilizado para crear la lista de guias de transporte que
  #se mostrara en el tabla. Crea la lista de acuerdo a las variables Origen y Destino
  #de la interfaz (Ciudades origen y destino), esta variables se envia por el params
  #:origin y :destiny
  #Retorna. Hace un respond a get_transport_guides.js.erb
  #
  def get_transport_guides
    origin= params[:origin]
    destiny=params[:destiny]
    if origin=='' || destiny==''
      @transport_guides=TransportGuide.where(id: 0);
    else
      @@origin=origin
      @@destiny=destiny
      @transport_guides=TransportGuide.where(origin_city_id: origin, destination_city_id: destiny, transport_guide_state_id: 1)
      @@transport_guides=@transport_guides
    end
    respond_to do |format|
      format.js
    end
  end
  def delete_detail
    @transport_guides= Set.new
    transport_guides_deleted= Set.new
    @@transport_guides.each do |item|
      if item.id != params[:id].to_i
        @transport_guides.add(item);
      else
        transport_guides_deleted.add(item)
      end
    end
    @@transport_guides=@transport_guides

    respond_to do |format|
      format.js
    end
  end
  
  def generate_cargo_manifest_pdf#(cargo_manifest)
    cargo_manifest = CargoManifest.find(params[:id]);
    respond_to do |format|
      format.pdf do
        create_date=Date.today.strftime("%d-%m-%Y")
        @file_path = "#{Rails.root}/app/views/reports/manifests/manifiesto_carga_#{cargo_manifest.manifest_num}_#{create_date}.pdf"
        employee= Employee.find(cargo_manifest.employee_id)
        pdf = CargoManifestReportPdf.new(create_date,employee,cargo_manifest)#,new_cargo_manifest_url, root_url, @file_path)
        begin
          pdf.render_file(@file_path)
        rescue
          #no se guardo el archivo
        end
        send_data pdf.render, filename: "manifiesto_carga_#{cargo_manifest.manifest_num}_#{create_date}.pdf",
          type: "application/pdf",
          disposition: "inline"
      end
    end

  end
 
  private
  def manejo_error_pg(cargo_manifest)
    respond_to do |format|
      format.html { redirect_to new_cargo_manifest_path,
        notice: "ERROR, Numero de Manfiesto de carga ingresado ya existe"}
      format.json { head :no_content }
    end
  end

  
end
