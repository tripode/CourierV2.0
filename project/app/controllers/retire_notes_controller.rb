require 'custom_logger'

class RetireNotesController < ApplicationController
  
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
    authorize! :create, RetireNote
  end


  # GET /retire_notes
  # GET /retire_notes.json
  def index
    @retire_note=RetireNote.new
    @retire_note.employee_id=current_user.employee.id
    @customer = Customer.new
    @customers = Customer.find(:all)
    @employees = Employee.find(:all)
    @retire_notes=Array.new
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @retire_note }
    end
  end

  # GET /retire_notes/1
  # GET /retire_notes/1.json
  def show
    flash[:notice]=""
    @retire_note = RetireNote.find(params[:id])
   
      
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @retire_note}
    
    end
  end

  # GET /retire_notes/new
  # GET /retire_notes/new.json
  def new
    flash[:notice]=""
    @retire_note = RetireNote.new
    @retire_note.date = @retire_note.format_date
    @retire_note.employee_id=current_user.employee.id
    @customer = Customer.new
    @customers = Customer.find(:all)
    @employees = Employee.find(:all)
    #En la lista muestro todas las notas de retiro no procesadas cuya fecha sea hasta 31 dias antes de la fecha actual
    @retire_notes= RetireNote.find(:all, :conditions=> "retire_note_state_id= 2 and date between current_date-31 and current_date")
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @retire_note }
    end
  end

  # GET /retire_notes/1/edit
  def edit
    flash[:notice]=""
    @retire_note = RetireNote.find(params[:id])
    @customers = Customer.find(:all)
    @employees = Employee.find(:all)
    respond_to do |format|
      format.js
    end
  end

  # POST /retire_notes
  # POST /retire_notes.json
  def create
    @retire_note = RetireNote.new(params[:retire_note])
    @retire_note.date = @retire_note.format_date
    @customers = Customer.find(:all)
    @employees = Employee.find(:all)
    @retire_notes= RetireNote.find(:all, :conditions=> "retire_note_state_id= 2 and date between current_date-31 and current_date")
    @retire_note.employee_id=current_user.employee.id
    @retire_note.retire_note_state_id=RetireNoteState.where("state_name='En Proceso'").first.id
 
    respond_to do |format|
      begin
        #Si la fecha de vencimiento es mayor o igual a la fecha de registrom entoces proceso
        if Date.parse(@retire_note.expiration_date.to_s) >= Date.parse(@retire_note.date.to_s) 
          if @retire_note.amount > 0
            if @retire_note.save
              flash[:notice]="La nota de retiro se guardo correctamente."
            else
              flash[:notice]="No se pudo guardar la nota de retiro."
              CustomLogger.error("No se pudo guardar la nota de retiro: #{@retire_note.inspect}, usuario: #{current_user.username}, #{Time.now}")
            end
            #Initialize al variables
              @retire_note = RetireNote.new
              @retire_note.date = @retire_note.format_date
              @retire_note.employee_id=current_user.employee.id
              @customer = Customer.new
              @customers = Customer.find(:all)
              @employees = Employee.find(:all)
              #En la lista muestro todas las notas de retiro no procesadas cuya fecha sea hasta 31 dias antes de la fecha actual
              @retire_notes= RetireNote.find(:all, :conditions=> "retire_note_state_id= 2 and date between current_date-31 and current_date")
          else
            flash[:notice]="No se guardo. La cantidad debe ser mayor a cero."
             CustomLogger.info("No se guardo. La cantidad debe ser mayor a cero: #{@retire_note.inspect}, usuario: #{current_user.username}, #{Time.now}")
          end
       else
         flash[:notice]="No se guardo. La fecha de vencimiento debe ser mayor o igual a la fecha de registro"
         CustomLogger.info("No se guardo la nota de retiro. La fecha de vencimiento debe ser mayor o igual a la fecha de registro: #{@retire_note.inspect}, usuario: #{current_user.username}, #{Time.now}")
       end
      rescue
        @exits_retire_note=RetireNote.where(number: @retire_note.number).first
        if !@exits_retire_note.nil?
          flash[:notice]="No se pudo guardar. El numero de nota ya existe."
          CustomLogger.error("No se guardo la nota de retiro. El numero de nota ya existe: #{@retire_note.inspect}, usuario: #{current_user.username}, #{Time.now}")
        else
          flash[:notice]="Error al guardar. Verifique los datos ingresados."
          CustomLogger.error("Error al guardar. Verifique los datos ingresados: #{@retire_note.inspect}, usuario: #{current_user.username}, #{Time.now}")
        end
      ensure
         format.js
      end
    end
  end

  # PUT /retire_notes/1
  # PUT /retire_notes/1.json
  def update
    @retire_note = RetireNote.find(params[:id])
    @customers = Customer.find(:all)
    @employees = Employee.find(:all)
    @retire_notes= RetireNote.find(:all, :conditions=> "retire_note_state_id= 2 and date between current_date-31 and current_date")
    @retire_note.employee_id=current_user.employee.id
    @retire_note.retire_note_state_id=RetireNoteState.where("state_name='En Proceso'").first.id
    respond_to do |format|
      begin
        #Si todavia no se ha registrado ninguno de sus productos entonces puede ser editado
        if @retire_note.amount_processed.to_i == 0
          #Si la fecha de vencimiento es mayor o igual a la fecha de registrom entoces proceso
          if Date.parse(@retire_note.expiration_date.to_s) >= Date.parse(@retire_note.date.to_s) 
            # Si la cantiadad que se ingresa en mayor a cero es valido para ser actualizado
            if params[:retire_note][:amount].to_i > 0
              if @retire_note.update_attributes(params[:retire_note])
                flash[:notice]='La nota de retiro ha sido actualizada'
              else
                flash[:notice]='No se pudo actualizar la nota de retiro'
                CustomLogger.info("No se pudo actualizar la nota de retiro #{@retire_note.inspect}, usuario: #{current_user.username}, #{Time.now}")
              end
              #Initialize al variables
                @retire_note = RetireNote.new
                @retire_note.date = @retire_note.format_date
                @retire_note.employee_id=current_user.employee.id
                @customer = Customer.new
                @customers = Customer.find(:all)
                @employees = Employee.find(:all)
                #En la lista muestro todas las notas de retiro no procesadas cuya fecha sea hasta 30 dias antes de la fecha actual
                @retire_notes= RetireNote.find(:all, :conditions=> "retire_note_state_id= 2 and date between current_date-31 and current_date")
            else
              flash[:notice]="No se actualizo. La cantidad debe ser mayor a cero"
              CustomLogger.info("No se pudo actualizar la nota de retiro. La cantidad debe ser mayor a cero #{@retire_note.inspect}, usuario: #{current_user.username}, #{Time.now}")
            end
          else
            flash[:notice]="No se actualizo. La fecha de vencimiento debe ser mayor o igual a la fecha de registro"
            CustomLogger.info("No se pudo actualizar la nota de retiro. La fecha de vencimiento debe ser mayor o igual a la fecha de registro #{@retire_note.inspect}, usuario: #{current_user.username}, #{Time.now}")
          end
       else
         flash[:notice]="Esta nota no puede ser actualizada, algunos de sus productos ya fueron registrados.."
              #Initialize al variables
              @retire_note = RetireNote.new
              @retire_note.date = @retire_note.format_date
              @retire_note.employee_id=current_user.employee.id
              @customer = Customer.new
              @customers = Customer.find(:all)
              @employees = Employee.find(:all)
              #En la lista muestro todas las notas de retiro no procesadas cuya fecha sea hasta 30 dias antes de la fecha actual
              @retire_notes= RetireNote.find(:all, :conditions=> "retire_note_state_id= 2 and date between current_date-31 and current_date")
       end
      rescue
        @exits_retire_note=RetireNote.where(number: @retire_note.number).first
        if !@exits_retire_note.nil?
          flash[:notice]="No se pudo actualizar. El numero de nota ya existe."
            CustomLogger.info("No se pudo actualizar la nota de retiro. El nro de nota ya existe #{@retire_note.inspect}, usuario: #{current_user.username}, #{Time.now}")
        else
          flash[:notice]="Error al actualizar, verifique los datos ingresados."
            CustomLogger.info("No se pudo actualizar la nota de retiro.Verifique los datos ingresados #{@retire_note.inspect}, usuario: #{current_user.username}, #{Time.now}")
        end
      ensure
         format.js
      end
    end
  end

  # DELETE /retire_notes/1
  # DELETE /retire_notes/1.json
  def destroy
    @retire_note = RetireNote.find(params[:id])
    respond_to do |format|
      begin
        @retire_note.destroy
        flash[:notice]="La nota de retiro ha sido eliminada.."
      rescue
        flash[:notice]="Esta nota de retiro no puede ser eliminada.."
         CustomLogger.info("Esta nota de retiro no puede ser eliminada #{@retire_note.inspect}, usuario: #{current_user.username}, #{Time.now}")
      ensure
       
        #Initialize al variables
            @retire_note = RetireNote.new
            @retire_note.date = @retire_note.format_date
            @retire_note.employee_id=current_user.employee.id
            @customer = Customer.new
            @customers = Customer.find(:all)
            @employees = Employee.find(:all)
            #En la lista muestro todas las notas de retiro no procesadas cuya fecha sea hasta 31 dias antes de la fecha actual
            @retire_notes= RetireNote.find(:all, :conditions=> "retire_note_state_id= 2 and date between current_date-31 and current_date")
       format.js 
      end
    end
  end
  
  
  # SEARCH post hace una consulta a la base de datos con los parametros que recibe del cliente
  def search
     @retire_notes=Array.new
     @retire_note=RetireNote.new # inicializo para usar metodos de formato de fecha que tiene nota de retiro
     @customers = Customer.find(:all) #necesito para el autocomplite
     
     #Obtengo los parametros para la consulta
     @number=params[:number]
     @customer_id=params[:customer_id]
     @start_date=params[:start_date]
     @end_date=params[:end_date]
     @product_type_id=params[:product_type_id]
     @state_id=params[:retire_note_state_id]
     #Verifico que se hayan ingresados los rangos de fechas de registros para realizar la busqueda
      valid_start_date=/[0-9]{2}-[0-9]{2}-[0-9]{4}/.match(@start_date)
      valid_end_date=/[0-9]{2}-[0-9]{2}-[0-9]{4}/.match(@end_date)
     
       begin
         if (!valid_start_date.nil? and !valid_end_date.nil?)
             @sql= " date between '" + @start_date + "' and '" + @end_date + "'"
             
             valid_number=/^\d+$/.match(@number)
             if !valid_number.nil? then @sql = @sql + " and number=" + @number end
             
             valid_customer_id=/^\d+$/.match(@customer_id)
             if !valid_customer_id.nil? then @sql = @sql + " and customer_id=" + @customer_id end
       
             valid_state_id=/^\d+$/.match(@state_id)
             if !valid_state_id.nil? then @sql=@sql + " and retire_note_state_id=" + @state_id end
             
             valid_product_type_id=/^\d+$/.match(@product_type_id)
             if !valid_product_type_id.nil? then @sql=@sql + " and product_type_id=" + @product_type_id end
             #Genero la consulta
             @retire_notes=RetireNote.where(@sql)
             if @retire_notes.empty? 
                @retire_notes = Array.new
             end
             flash[:notice]=""
             respond_to do |format|
               format.js
             end
          end
       rescue 
         flash[:notice]="Error al buscar los productos"
         CustomLogger.error("Error al buscar los productos, usuario: #{current_user.username}, #{Time.now}")
          respond_to do |format|
            format.js
          end
      end
   end
   
   #Este metodo permite setear obtener el precio para la nota de retiro
   #teniendo en cuenta el cliente, el tipo de producto y la ciudad     
   def getPrice
     @customer_id = params[:customer_id]
     @product_type_id = params[:product_type_id]
     @city_id = params[:city_id]
     @current_date = params[:current_date]
     @from_date = @current_date.to_date - 1.month    
     @retire_note = RetireNote.where("customer_id=? and product_type_id=? and city_id=? and date between ? and ?", @customer_id,@product_type_id, @city_id,@from_date.to_s,@current_date.to_date).last
     @price = 0
     if !@retire_note.nil? 
       @price = @retire_note.unit_price
     end
     @the_price = {"value" => @price.to_i}
     respond_to do |format|
        format.html # 
        format.json { render json: @the_price }
    end
   end
end
