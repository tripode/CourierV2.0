class ProductsController < ApplicationController
  
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
    authorize! :create, Product
  end
  
  
  # GET /products
  # GET /products.json
  def index
   $products = Array.new
   @customers=Customer.all
   @cities=City.all
   $product=Product.new
   $receivers = Receiver.find(:all)
   $addresses=Array.new
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: $products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    flash[:notice]=""
    @cities = City.all
    
    $product = Product.new
    $product.created_at=$product.format_admission_date
    $products=Array.new
    #Obtengo la lista de notas de retiro para mostrar en el autocom´ete
    #En la lista muestro todas las notas de retiro no procesadas cuya fecha sea hasta 31 dias antes de la fecha actual
    $retire_notes= RetireNote.find(:all, :conditions=> "retire_note_state_id= 2 and date between current_date-31 and current_date")
    $receivers = Receiver.find(:all)
    
    $addresses=Array.new
    $item = 1
      respond_to do |format|
      format.html # new.html.erb
      format.json { render json: $product }
    end
  end

  # GET /products/1/edit
  def edit
    flash[:notice]=""
    @product_state= ProductState.new
    @product = Product.find(params[:id])
    #El producto no puede ser editado si su estado es recibido
    if @product.product_state_id == ProductState.recibido 
      flash[:notice]="Este producto no puede ser editado."
    end
    
  end

  # POST /products
  # POST /products.json
  def create
    flash[:notice]=""
    #Variables para inicializar popin destinatario
    @cities = City.all
    #Variables de la clase
    $product = Product.new(params[:product])
    $product.product_state_id = ProductState.no_enviado #Estado por defecto del producto es No enviado id = 2
    $product.created_at=$product.format_admission_date
    @retire_note_id=$product.retire_note_id
    @product_type_id=$product.product_type_id
    @retire_note=RetireNote.find(@retire_note_id)
    @amount=RetireNote.where(id: @retire_note_id).first.amount
    respond_to do |format|
    begin  
      if $product.save
        $products.push($product)
        $product=Product.new
        $product.created_at=$product.format_admission_date
        #actualiza la amount_processed de nota de retiro
        begin
          @retire_note.update_attribute(:amount_processed, $item)
        rescue
          flash[:notice]="No se pudo actualizar la cantidad de la nota"
          logger.error("No se pudo actualizar la cantidad de la nota de retiro: #{@retire_note}, usuario: #{current_user.username}, #{Time.now}")
        end
        #Controla que se ingreso todos los productos de la nota de retiro
         if ($item.to_i < @amount.to_i)
          $item= $item + 1
          $product.retire_note_id = @retire_note_id
          $product.product_type_id = @product_type_id
          $product.product_state_id = ProductState.no_enviado #ProductState.where("state_name='No enviado'").first.id
          format.js
         else
            $item= 1 #seteo item a 1 para los productos de una nueva nota de retior
            #Cambio de estado la nota de retiro registrado de "En Proceso" a "Procesado"
            begin
              @state_id=RetireNoteState.where("state_name='Procesado'").first.id
              @retire_note.update_attribute(:retire_note_state_id, @state_id)
              flash[:notice]="Esta nota se ha procesado con exito."
            rescue
              logger.error("Error al procesar la nota de retiro: #{@retire_note}, usuario: #{current_user.username}, #{Time.now}")
            end
            $product = Product.new
            $product.created_at=$product.format_admission_date
            #init all--------------
            #Obtengo la lista de notas de retiro para mostrar en el autocom´ete
            #En la lista muestro todas las notas de retiro no procesadas cuya fecha sea hasta 31 dias antes de la fecha actual
            $retire_notes= RetireNote.find(:all, :conditions=> "retire_note_state_id= 2 and date between current_date-31 and current_date")
            $receivers = Receiver.find(:all)
           
            $addresses=Array.new
            $item = 1
            ##----------
            format.js
         end
      else
        #init all--------------
            #Obtengo la lista de notas de retiro para mostrar en el autocom´ete
            #En la lista muestro todas las notas de retiro no procesadas cuya fecha sea hasta 31 dias antes de la fecha actual
            $retire_notes = RetireNote.find(:all, :conditions=> "retire_note_state_id= 2 and date between current_date-31 and current_date")
            $receivers = Receiver.find(:all)
            $product_state = ProductState.new
            $product.product_state_id = ProductState.no_enviado #ProductState.where("state_name='No enviado'").first.id ##Por defecto el estado es "No Enviado"
            
            $addresses=Array.new
            $item = 1
            ##----------
        format.js
      end
    rescue
      flash[:notice]="Atencion.!! El codigo ingresado ya fue registrado.. Introdusca otro codigo de barras por favor"
      logger.error("Se intento guardar un producto con un codigo de barras repetido: #{$product.bar_code}, usuario: #{current_user.username}, #{Time.now}")
      format.js
    end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])
    @product_state= ProductState.new
    respond_to do |format|
      begin
        ## Si el estado del producto es Recibido  no se puede actualizar porque
        ## los productos ya se procesaron
        if @product.product_state_id.to_i != ProductState.recibido.to_i 
          if @product.update_attributes(params[:product])
            flash[:notice]="El producto ha sido actualizado"
             logger.info("Se actualiza el producto: #{@product.inspect}, usuario: #{current_user.username}, #{Time.now}")
          end
        else
           flash[:notice]="El producto no pudo ser actualizado"
           logger.info("No se pudo actualizar el producto: #{@product.inspect}, usuario: #{current_user.username}, #{Time.now}")
        end
         format.js
        
      rescue
        logger.error("Error al actualizar el producto: #{@product.inspect}, usuario: #{current_user.username}, #{Time.now}")
        flash[:notice]="El producto no pudo ser actualizado."
      ensure
        format.js
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @retire_note_id=@product.retire_note_id
    @retire_note=RetireNote.where(id:  @retire_note_id).first
    @amount_processed=@retire_note.amount_processed
    begin
      if @product.destroy 
        ##Actualizo la cantidad de productos registrados de la nota de retiro. Se elimino un producto , se resta 1
        @amount_processed=@amount_processed - 1
        @retire_note.update_attribute(:amount_processed, @amount_processed) 
        flash[:notice]="El producto se ha eliminado."
      end
      logger.info("Se borra el producto: #{@product.inspect}, usuario: #{current_user.username}, #{Time.now}")
    rescue
      logger.error("Error al borrar el producto: #{@product.inspect}, usuario: #{current_user.username}, #{Time.now}")
      flash[:notice]="Este producto no puede ser eliminado."
    end
    $products=Product.where(retire_note_id: @retire_note_id)
    @cities= City.all
    respond_to do |format|
      format.js
      #format.html { redirect_to new_product_path }
      #format.json { head :no_content }
    end
  end
  
  #post
  #Metodo que retorna un objecto product_type
  #busca el product_type mediante el id del product_type
  #pasado como parametro
  
  def getProductType
   @product_type_description=ProductType.where(id: params[:id]).first.description
   @product_type={description: @product_type_description}
   respond_to do |format|
         format.html #need for ajax with html datatype 
         format.json { render json: @product_type }#need for ajax with json datatyp 
    end
  end
  
  #post Este metodo se encarga de actualizar la lista de receivers, devuelve la lista
  # para que sea procesada en la  pagina para el autocomplete
  def update_new_receiver
    
    @receiver_added = Receiver.last
    $receivers << @receiver_added
    respond_to do |format|
      format.html
      format.json {render json: $receivers}
    end
  end
  
  
  #post
  #Metodod que retorna un objecto que contiene las direcciones del destinatario
  #Busca las direcciones con el id del destinatario que se le pasa por parametro
  def getReceiverAddress
   
    $addresses= ReceiverAddress.where(receiver_id: params[:id]);
   respond_to do |format|
         format.html #need for ajax with html datatype 
         format.json { render json: $addresses }#need for ajax with json datatyp
    end
  end
  
  #post
  #Metodo que retorna un customer. Procesa el id del customer 
  #que recibe dentro de params. Es invocado via ajax desde el form _product
  def getCustomer
    @customer=Customer.where(id: params[:id]).first
   respond_to do |format|
         format.html #need for ajax with html datatype 
         format.json { render json: @customer }#need for ajax with json datatyp 
    end
  end
  
  #post
  #Metodo que retorna el item correcspondiente al producto que se va a registrar
  def getItem
    @amount=params[:amount]
    @amount_processed=RetireNote.where(id: params[:id]).first.amount_processed
    $item=@amount_processed
    if ($item.to_i < @amount.to_i)
      $item= $item + 1
    end
    @objectItem={item: $item}
    respond_to do |format|
         format.html #need for ajax with html datatype 
         format.json { render json: @objectItem }#need for ajax with json datatyp 
    end
  end
  #post
  #Metodo para buscar los productos de la nota de retiro de retiro si ya existe en la base de datos
  def getListProducts
    $products=Product.where(retire_note_id: params[:id])
    respond_to do |format|
         format.js
    end
  end
  #post
  #Metodo que retorna la ciudad correcspondiente a una direccion
  def getCity
    @city_id=ReceiverAddress.where(id: params[:address_id]).first.city_id
    @city=City.where(id: @city_id).first
    respond_to do |format|
      format.html
      format.json {render json: @city}
    end
  end
  #Metodo post para realizar busquedas de productos
  def search
    @retire_note_number=params[:retire_note_number]
    @customer_id=params[:customer_id]
    @product_type_id=params[:product_type_id]
    @inited_at=params[:inited_at]
    @finished_at=params[:finished_at]
    @receiver_id=params[:receiver_id]
    @city_id=params[:city_id]
    @product_state_id=params[:product_state_id]
    @bar_code=params[:bar_code]
    
   #filtro por las fechas de inicio y fin
    valid_inited_at=/[0-9]{2}-[0-9]{2}-[0-9]{4}/.match(@inited_at)
    valid_finished_at=/[0-9]{2}-[0-9]{2}-[0-9]{4}/.match(@finished_at)
    if(!valid_inited_at.nil? && !valid_finished_at.nil?) 
      @sql=" 1=1 "
      @sql = @sql + " and products.created_at between '" + @inited_at.to_s + "' and '" + @finished_at.to_s + "'"
    
        
        #Si es distinto de nil es un numero
        valid_number=/^\d+$/.match(@retire_note_number)

        if(!valid_number.nil?) 
        
          @retire_note=RetireNote.where(number: @retire_note_number).first
          if (!@retire_note.nil?) 
            @sql = @sql + " and products.retire_note_id=" + @retire_note.id.to_s
          else
            @sql = @sql + " and products.retire_note_id= -1" 
          end
        end
        #Si se selecciono algun tipo de producto entonces agrego a la consulta
        valid_product_type_id=/^\d+$/.match(@product_type_id)
        if(!valid_product_type_id.nil?) 
          @sql = @sql + " and products.product_type_id=" + @product_type_id.to_s
        end
        #Si se selecciono algun tipo de estado entonces agrego a la consulta
        valid_product_state_id=/^\d+$/.match(@product_state_id)
        if(!valid_product_state_id.nil?)
          @sql = @sql + " and products.product_state_id=" + @product_state_id.to_s
        end
        
         #Si se selecciono algun destinatario agrego a la consulta
        valid_receiver_id=/^\d+$/.match(@receiver_id)
        if(!valid_receiver_id.nil?) 
         @sql = @sql + " and receiver_id=" + @receiver_id.to_s
        end
        #Si hay codigo de barras agrego a la consulta
        valid_barcode=/^\d+$/.match(@bar_code)
        if(!valid_barcode.nil?) 
          @sql = @sql + " and products.bar_code='" + @bar_code.to_s + "'"
        end
        
        #Si hay cliente agrego a la consulta
        valid_customer_id=/^\d+$/.match(@customer_id)
        if(!valid_customer_id.nil?) 
          $products=Product.joins("inner join retire_notes r on r.id=products.retire_note_id" +
          " inner join customers c on c.id=r.customer_id  where c.id=" + @customer_id.to_s + " and " + @sql)
        else
          $products=Product.where(@sql)
        end  
    else
       $products=Array.new
    end
    respond_to do |format|
      format.js
    end
  end
  
  
  ## Metodo que redirige a la pagina products_by_customer
  def delivery_report
    @product=Product.new
    @details=Array.new
    @customers=Customer.all
    @retire_notes= RetireNote.where("date between current_date-31 and current_date and retire_note_state_id = 1")
    respond_to do |format|
      format.html # products_by_customer.html.erb
      format.json { render json: @product }
    end
  end
  
  #Post method: Este metodo genera el informe para el cliente de los products
  #entregados entre un rango de fecha
  def generate_delivery_report
  
    
    @customer_id = params[:customer_id]
    @report_date = params[:report_date]
    @retire_note_number = params[:retire_note_number]
    @retire_note_id = params[:retire_note_id]
    @details= Array.new
    @products= Array.new
    valid_retire_note_number=/^\d+$/.match(@retire_note_number)
    valid_report_date=/[0-9]{2}-[0-9]{2}-[0-9]{4}/.match(@report_date)
    if( !valid_retire_note_number.nil? and !valid_report_date.nil?) 
      
      ## Obtengo todos los productos de esa nota de retiro cuyo id es el pasado por parametro
      @products = Product.where(retire_note_id: @retire_note_id)
      if(!@products.empty?)
        ## Busco el detalle de hoja de ruta de cada producto
        @products.each do |product|
          ##Si tiene detalle, quiere decir que el producto ha sido ruteado, obtengo el ultimo
          ## detalle del producto por si se ruteo mas de una ves.
          @routing_sheet_detail = RoutingSheetDetail.where(product_id: product.id).last
          #Si exite un detalle para ese producto, este producto ha sido ruteado
          if(!@routing_sheet_detail.nil?)
              # si ya no se agrego el detalle, lo agrego
              if !@details.include?(@routing_sheet_detail)
                @details << @routing_sheet_detail
              end
          else
           #Creo un detalle para un producto no ruteado solo para mostrar en el informe
           #como "No Ruteado" 
              @detalle_product_no_routed = RoutingSheetDetail.new
              @detalle_product_no_routed.product_id = product.id
              @details << @detalle_product_no_routed
          end
        end
      end
      @product_type_id = RetireNote.where(id: @retire_note_id).first.product_type_id
      @product_type = ProductType.where(id: @product_type_id).first.description
      @customer=Customer.where(id: @customer_id).first
      @employee=current_user.employee
    end
    ## Comparo si la vista pide un archivo csv o pdf
      if params[:commit]=="Descargar Excel"
         respond_to do |format|
            format.csv do
              create_date=Date.today
              create_date.strftime("%d-%m-%Y") if create_date
              csv_report = DeliveryReportCsv.new(@product_type,@customer,@employee,@details,@file_path,getMonth(Date.parse(@report_date).month),Date.parse(@report_date).year)
              csv_string = csv_report.getCSV
                # envia al browser
              send_data csv_string, 
                        :type => 'text/csv; charset=iso-8859-1; header=present', 
                        :disposition => "attachment; filename=informe_#{@customer.company_name + @customer.last_name + @customer.name + "_" + create_date.to_s}.csv" 
            end
         end
      else  if params[:commit]=="Generar PDF"
           respond_to do |format|
              format.pdf do
                create_date=Date.today
                create_date.strftime("%d-%m-%Y") if create_date
                @file_path = "#{Rails.root}/app/views/reports/informe_Nota#{@retire_note_number}_#{@customer.company_name  + @customer.last_name  + @customer.name}_#{create_date}.pdf"
                pdf = DeliveryReportPdf.new(@product_type,@customer,@employee,@details,delivery_report_products_url,root_url,@file_path, getMonth(Date.parse(@report_date).month),Date.parse(@report_date).year )
                begin
                
                  pdf.render_file(@file_path)
                rescue
                  #no se guardo el archivo
                  logger.info("Error al crear pdf: #{pdf.inspect}, usuario: #{current_user.username}, #{Time.now}")
                end
                pdf.move_cursor_to 40
                pdf.text("<u><a href='#{root_url}products/send_email?customer_id=#{@customer.id}&file_path=#{@file_path}&report_date=#{@report_date}' method='post'>Enviar</a></u>   <u><link href='#{delivery_report_products_url}'>Nuevo reporte</link></u>  <u><link href='#{root_url}main_page/index'>Cancelar</link></u> ",:inline_format => true, :page_number => "1")
                send_data pdf.render, filename: "informe_#{@customer.company_name  + @customer.last_name  + @customer.name}_#{create_date}.pdf",
                                      type: "application/pdf",
                                      disposition: "inline"
              end
           end
        end
      end
  end
   
  ##
  # Envia el pdf al email del cliente
  # 
  def send_email
    @costumer_id = params[:customer_id]
    @file_path = params[:file_path]
    @report_date=params[:report_date]
    @costumer = Customer.find(@costumer_id)
    EmailSender.eemail(@costumer.email, @file_path, @report_date).deliver
    logger.info("Se envia email a: #{@customer.inspect}, usuario: #{current_user.username}, #{Time.now}")
    respond_to do |format|
      format.html {redirect_to  delivery_report_products_path}
      format.json { head :no_content }
    end
  end
  
  
  ##
  # Este metodo guarda un nuevo receiver
  #
  def save_receiver
    # se limpia los datos y se guarda el nuevo destinatario
    name = params[:receiver_name]
    document = params[:document]
    Receiver.transaction do 
      receiver = Receiver.create(receiver_name: name, document: document );
      
        addresses = []
        params[:addresses].each do |address|
          number = address[0]
          place = address[1][:place]
          city_id = address[1][:city_id]
          address = address[1][:address]
          
          address = ReceiverAddress.create(label: place, address: address, city_id: city_id, receiver_id: receiver.id)
        end
        logger.info("Se guarda el destinatario: #{receiver.inspect}, usuario: #{current_user.username}, #{Time.now}")
    end
    @object={success: 1}
    respond_to do |format|
      format.html 
      format.json { render json: @object}
    end
    
  end
  
  
  private
  def getMonth(month_number)
    months = %w("Enero Febrero Marzo Abril Mayo Junio Julio Agosto Setiembre Octubre Noviembre Diciembre")
    return months[month_number - 1] 
  end
end
