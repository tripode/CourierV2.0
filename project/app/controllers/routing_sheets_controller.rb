class RoutingSheetsController < ApplicationController
  
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
    authorize! :create, RoutingSheet
  end
  
  
  
  # GET /routing_sheets
  # GET /routing_sheets.json
  def index
    @routing_sheets = Array.new
    @routing_sheet=RoutingSheet.new
    @area = Area.new
    @routing_states= RoutingSheetState.new
    @employees=Employee.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @routing_sheets }
    end
  end
  # GET /routing_sheets/report
  # GET /routing_sheets/report.json
  def report
    @employees=Employee.all
    @routing_sheets=RoutingSheet.find(:all, :conditions=> "routing_sheet_state_id=1") ## 1 = "En Proceso"
    $routing_sheets_details=Array.new
    respond_to do |format|
      format.html # report.html.erb
      format.json {render json: @routing_sheet }
    end
  end
  # GET /routing_sheets/1
  # GET /routing_sheets/1.json
  def show
    @routing_sheet = RoutingSheet.find(params[:id])
    @routing_sheets_details= RoutingSheetDetail.where(routing_sheet_id: params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @routing_sheet }
      format.pdf do
        pdf = RoutingSheetPdf.new(@routing_sheet,@routing_sheets_details, root_url)
        send_data pdf.render, filename: "hoja_de_ruta_#{@routing_sheet.id}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  # GET /routing_sheets/new
  # GET /routing_sheets/new.json
  def new
    flash[:notice]=""
    @routing_sheet = RoutingSheet.new
    $products= Array.new
    @area= Area.new
    $total=0;
    @start_value=ActiveRecord::Base.connection.execute("select start_value from routing_sheets_id_seq").first["start_value"]
    $number=ActiveRecord::Base.connection.execute("select last_value from routing_sheets_id_seq").first["last_value"]
    #La primera ves que se registra una hoja de ruta se setea como numero 1
    if(@start_value.to_i == $number.to_i) 
      @first=RoutingSheet.first

      if(!@first.nil?) 
        $number= 2
      else
        $number= 1
      end
      @routing_sheet.number= $number.to_i #
    else
      @routing_sheet.number=$number.to_i + 1
    end
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @routing_sheet }
    end
  end

  # GET /routing_sheets/1/edit
  def edit
    @routing_sheet = RoutingSheet.find(params[:id])
    ##Solo se puede editar una hoja de ruta cuyo estado sea "En Proceso" id = 1
    if (@routing_sheet.routing_sheet_state_id == 1 )
      @routing_sheets_details=RoutingSheetDetail.where(routing_sheet_id: params[:id])
      $products=Array.new
     
      @routing_sheets_details.each do |detail|
        @product=Product.where(id: detail.product_id).first
        $products << @product
      end
      $total=$products.length
    end
    @area= Area.new
  end

  # POST /routing_sheets
  # POST /routing_sheets.json
  def create
  
    @routing_sheet = RoutingSheet.new(params[:routing_sheet])
    @routing_sheet.employee_id=current_user.employee.id #Seteo el user logueado
    @routing_sheet.routing_sheet_state_id = 1 ## Por defecto el estado es "En Proceso", id: 1
    @routing_sheet.total_amount=$total
    @start_value=ActiveRecord::Base.connection.execute("select start_value from routing_sheets_id_seq").first["start_value"]
    $number=ActiveRecord::Base.connection.execute("select last_value from routing_sheets_id_seq").first["last_value"]
    #La primera ves que se registra una hoja de ruta se setea como numero 1
    if(@start_value.to_i==$number.to_i) 
      @first=RoutingSheet.first
      if(!@first.nil?) 
        $number= 2
      else
        $number= 1
      end
     
      @routing_sheet.number= $number.to_i #
    else
      @routing_sheet.number=$number.to_i + 1
    end
    respond_to do |format|
      if $products.empty?
          format.html { redirect_to new_routing_sheet_path, notice: 'Prohibido guardar sin agregar algun producto..' }
          format.json { head :no_content }
      else
        begin
          RoutingSheet.transaction do
          @routing_sheet.save #Guardo la cabecera
          $products.each do |product| #Guardo los detalles
              @routing_sheet_detail=RoutingSheetDetail.new
              @routing_sheet_detail.routing_sheet_id=@routing_sheet.id
              @routing_sheet_detail.product_id=product.id
            
              @routing_sheet_detail.save
              @new_product_state_id= ProductState.enviado # id 1="Enviado" ProductState.where("state_name='Enviado'").first.id
              product.update_attribute(:product_state_id,  @new_product_state_id)
            end
          end
          format.html { redirect_to @routing_sheet, notice: 'La Hoja de Ruta se guardo con exito.' }
          format.json { render json: @routing_sheet, status: :created, location: @routing_sheet }
        rescue
          logger.error("No se pudo guardar la hoja de ruta: #{@routing_sheet.inspect}, usuario: #{current_user.username}, #{Time.now}")
          format.html { redirect_to new_routing_sheet_path, notice: 'No se pudo guardar la hoja de ruta..' }
          format.json { head :no_content }
        end
      end
    end
  end

  # PUT /routing_sheets/1
  # PUT /routing_sheets/1.json
  def update
  
    @routing_sheet = RoutingSheet.find(params[:id])

    respond_to do |format|
      if $products.empty?
        logger.error("No se pudo actualizar la hoja de ruta sin productos: #{@routing_sheet.inspect}, usuario: #{current_user.username}, #{Time.now}")
        format.html { redirect_to edit_routing_sheet_path, notice: 'Prohibido actualizar sin productos..' }
        format.json { head :no_content }
      else
        begin
           RoutingSheet.transaction do
             ##Primero elimino los detalles de la hoja de ruta actualizada de la base de datos
             @routing_sheets_details=RoutingSheetDetail.where(routing_sheet_id: @routing_sheet.id)
             @routing_sheets_details.each do |detail|
               ##Actaulizo el estado del producto a No enviado porque se elimina el detalle que hace referencia a el
               @product=Product.where(id: detail.product_id).first
               @old_product_state_id = ProductState.no_enviado ## id 2= "No enviado" ProductState.where("state_name='No enviado'").first.id
               @product.update_attribute(:product_state_id,  @old_product_state_id)
               #Elimino el detalle de la base de datos
               detail.destroy
             end
             
             @routing_sheet.update_attributes(params[:routing_sheet])
             @routing_sheet.update_attribute(:total_amount, $products.length)
             
             ##Creo los nuevos detalles de la hoja de ruta actualizada e inserto en la base de datos
             $products.each do |product| #guardo los nuevos detalles
               @routing_sheet_detail=RoutingSheetDetail.new
               @routing_sheet_detail.routing_sheet_id=@routing_sheet.id
               @routing_sheet_detail.product_id=product.id
               @routing_sheet_detail.save
              
               @new_product_state_id = ProductState.enviado ## id 1 ="Enviado" ProductState.where("state_name='Enviado'").first.id
               @product=Product.where(id: product.id).first
               @product.update_attribute(:product_state_id,  @new_product_state_id)
              
            end
            
            format.html { redirect_to @routing_sheet, notice: 'La Hoja de Ruta se actualizo correctamente.' }
            format.json { head :no_content }
          end
        rescue
          logger.error("No se pudo actualizar la hoja de ruta: #{@routing_sheet.inspect}, usuario: #{current_user.username}, #{Time.now}")
          format.html { redirect_to @routing_sheet, notice: 'La Hoja de Ruta no se pudo actualizar.' }
          format.json { head :no_content }
        end
      end
    end
  end

  # DELETE /routing_sheets/1
  # DELETE /routing_sheets/1.json
  def destroy
    @routing_sheet = RoutingSheet.find(params[:id])
    
    respond_to do |format|
      ##Solo se pueden eliminar las hojas de rutas cuyo estado en "En Proceso" id=1
       if (@routing_sheet.routing_sheet_state_id == 1 )
           begin
             RoutingSheet.transaction do
               ##Primero elimino los detalles de la hoja de ruta actualizada de la base de datos
               @routing_sheets_details=RoutingSheetDetail.where(routing_sheet_id: @routing_sheet.id)
               @routing_sheets_details.each do |detail|
                 ##Actaulizo el estado del producto a No enviado porque se elimina el detalle que hace referencia a el
                 @product=Product.where(id: detail.product_id).first
                 @old_product_state_id = ProductState.no_enviado ## id 2= "No enviado" ProductState.where("state_name='No enviado'").first.id
                 @product.update_attribute(:product_state_id,  @old_product_state_id)
                 #Elimino el detalle de la base de datos
                 detail.destroy
               end
               #Se elimina la hoja de ruta de la base de datos
               @routing_sheet.destroy
           
              format.html { redirect_to routing_sheets_url, notice: 'La hoja de ruta se ha eliminado' }
              format.json { head :no_content }
            end
          rescue
           logger.error("No se pudo eliminar la hoja de ruta. Puede estar siendo utilizada.: #{@routing_sheet.inspect}, usuario: #{current_user.username}, #{Time.now}")
           format.html { redirect_to routing_sheets_url, notice: 'Error al intentar eliminar esta hoja de ruta. Puede estar siendo utilizada.' }
           format.json { head :no_content }
          end
      else
           logger.error("No se puede eliminar la hoja de ruta. Esta siendo utilizada.: #{@routing_sheet.inspect}, usuario: #{current_user.username}, #{Time.now}")
           format.html { redirect_to routing_sheets_url, notice: 'No se puede eliminar porque ya ha sido procesada.' }
           format.json { head :no_content }
      end
      
    end
  end
  ## Agrega el producto a la lista, pasando como parametro el codigo de barra el producto
  def add_product
    @bar_code=params[:bar_code]
    @product_state_id = ProductState.no_enviado ## id 2="No enviado" ProductState.where("state_name='No enviado'").first.id
    @product=Product.where("bar_code=? and (product_state_id=? or product_state_id=?)",@bar_code, @product_state_id, ProductState.pendiente).first
    if !@product.nil?
        #Verifica si el producto ya fue cargado en lalista
      if !$products.include?(@product)
        $products << @product
        $total=$total + 1  
      end
    end
    respond_to do |format|
      format.js
    end
  end
  
  ## Get Elimina el producto de la lista
  def delete_product
    @product=Product.where(id: params[:id]).first
    if $products.include?(@product)
      $products.delete(@product)
      $total = $total - 1
    end
    respond_to do |format|
      format.js
    end
  end
  
  ## Post search: busca productos pasandole parametros
  def search
    @number=params[:number]
    @employee_id=params[:employee_id]
    @area_id=params[:area_id]
    @state_id=params[:routing_sheet_state_id]
    @date_start=params[:date_start]
    @date_end=params[:date_end]
   
  
    #filtro por las fechas de inicio y fin
    valid_inited_at=/[0-9]{2}-[0-9]{2}-[0-9]{4}/.match(@date_start)
    valid_finished_at=/[0-9]{2}-[0-9]{2}-[0-9]{4}/.match(@date_end)
    
    if (!valid_inited_at.nil? and !valid_finished_at.nil?) 
      @sql=" 1=1 "  
      valid_number=/^\d+$/.match(@number)
      if(!valid_number.nil?) 
        @sql = @sql + " and number=" + @number
      end
      valid_employee=/^\d+$/.match(@employee_id)
      if(!valid_employee.nil?) 
        @sql = @sql + "and employee_id=" + @employee_id
      end
      valid_area=/^\d+$/.match(@area_id)
      if(!valid_area.nil?) 
        @sql = @sql + " and area_id=" + @area_id
      end
      valid_state=/^\d+$/.match(@state_id)
      if(!valid_state.nil?) 
        @sql = @sql + " and routing_sheet_state_id=" + @state_id
      end
      
      @sql = @sql + " and date between '" + @date_start + "' and '" + @date_end + "'"
      @routing_sheets= RoutingSheet.where(@sql)
      if(@routing_sheets.empty?) 
         @routing_sheets=Array.new 
      end 
    else
      @routing_sheets=Array.new
    end
    
    @routing_sheet=RoutingSheet.new
    @area = Area.new
    @routing_states= RoutingSheetState.new
    @employees=Employee.all
    respond_to do |format|
      format.js
    end
  end
  #post search details by routing_sheet id
  def get_details
    @routing_sheet_id=params[:routing_sheet_id]
    valid_routing_sheet_id=/^\d+$/.match(@routing_sheet_id)
      if(!valid_routing_sheet_id.nil?) 
          $routing_sheets_details=RoutingSheetDetail.where(routing_sheet_id: @routing_sheet_id)    
      else
          $routing_sheets_details=Array.new
      end
    
    respond_to do |format|
      format.js
    end  
  end
  ##Este metodo permite guardar los detalles
  def save_edited_details
    RoutingSheetDetail.transaction do
      @routing_sheet_id = -1
      $routing_sheets_details.each do  |detail|
        @who_received=params['who_received_' + ($routing_sheets_details.index(detail) + 1).to_s]
        @reason_id=params['reason_id_' + ($routing_sheets_details.index(detail) + 1).to_s]
        @to_route = params['to_route_' + ($routing_sheets_details.index(detail) + 1).to_s]
        @detail_to_update=detail
        @product=Product.where(id: detail.product_id).first
        valid_received=/^\D{4,35}$/.match(@who_received)
        if(!valid_received.nil?) 
          ##Actualizo el detalle
          @detail_to_update.update_attribute(:who_received, @who_received)
          @detail_to_update.update_attribute(:received,'s') ## s= fue recibido el producto
          ##Actualizo el estado del producto a "Entregado" y la fecha en que recibio el producto
          
          @product.update_attribute(:product_state_id,ProductState.recibido)  ## id 6="Recibido" ProductState.where("state_name='Recibido'").first.id
          @product.update_attribute(:received_at, @product.format_admission_date)
        else
          #Actualizo el motivo por el cual no se entrego el producto
          #En caso de que el motivo sea "Producto Extraviado en el reparto
          #actualizo el estado del producto a extraviado, sino a "No recibido"
           @detail_to_update.update_attribute(:reason_id, @reason_id)
           
          if @reason_id.to_i == 14 # Rason de "Producto Extraviado"
            @product.update_attribute(:product_state_id,ProductState.extraviado) ## id 4= Extraviado
          else 
            if @reason_id.to_i == 15 # Rason de "Cancelado a pedido del cliente"
              @product.update_attribute(:product_state_id,ProductState.devuelto ) ## id 3= Devuelto
            else
              ## Si se marco la opcion para volver a rutear a "no", entonces coloco el estado a "no recibido"
              if @to_route.to_s == "no"
                @product.update_attribute(:product_state_id,ProductState.no_recibido) ## id 7= No recibido  
              else
                # Si se marco a "si", este producto cambia su estado a "Pendiente", y puede volver a rutearse
                @product.update_attribute(:product_state_id,ProductState.pendiente)
              end
            end
          end
        end
        
        ##Obtengo el id de la hoja de ruta 
        @routing_sheet_id=detail.routing_sheet_id
      end
      if(@routing_sheet_id != -1)
        @routing_sheet=RoutingSheet.where(id: @routing_sheet_id).first
        ##Cambio el estado de la hoja de ruta a procesado.
        @routing_sheet.update_attribute(:routing_sheet_state_id, 2 ) ## id 2 ="Procesado"
      end
    end
    respond_to do |format|
       format.html { redirect_to @routing_sheet, notice: 'Los detalles se actualizaron correctamente' }
       format.json { render json: @routing_sheet, status: :created, location: @routing_sheet }
    end
  end
end
