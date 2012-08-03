class InvoicesController < ApplicationController
   #
  # Antes de hacer cualquier cosa con este controler,
  # se verifica si hay permiso para el usuario logueado
  #
  before_filter :check_permissions
  skip_before_filter :require_no_authentication
  #
  # Llama a este metodo y verifica los permisos que tiene para Area
  #
  def check_permissions
    authorize! :create, Invoice
  end
  
  
  # GET /invoices
  # GET /invoices.json
  def index
    @invoice = Invoice.new
    @customers = Customer.all
    @invoices = Array.new
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invoice }
    end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    @invoice = Invoice.find(params[:id])
    @details = InvoiceDetail.where(invoice_id: @invoice.id)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @invoice }
      format.pdf do
      pdf = InvoiceDetailPdf.new(@invoice,@details)
      send_data pdf.render, filename: "detalle_factura_numero_#{@invoice.number}.pdf",
                type: "application/pdf",
                disposition: "inline"
      end
    end
  end

  # GET /invoices/new
  # GET /invoices/new.json
  def new
    @invoice = Invoice.new
    $details = Array.new
    @customers = Customer.all
    @retire_notes = Array.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invoice }
    end
  end

  # GET /invoices/1/edit
  #def edit
   # @invoice = Invoice.find(params[:id])
  #end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(params[:invoice])
    @customers = Customer.all
    respond_to do |format|
      result = @invoice.save_invoice(@invoice,$details)
      if result.to_i == 0
        format.html { redirect_to @invoice, notice: 'La factura se guardo correctamente.' }
        format.json {  head :no_content }
      end
      if result.to_i == 1
        format.html { redirect_to new_invoice_path, notice: 'No se pudo guardar la factura, el numero de factura ingresado no es valido' }
        format.json { head :no_content }
      end
      if result.to_i == 2
        format.html { redirect_to new_invoice_path, notice: 'No se pudo guardar la factura, el numero de factura ingresado ya existe' }
        format.json { head :no_content }
      end
      if result.to_i == 3
        format.html { redirect_to new_invoice_path, notice: 'No se puede guardar una factura sin detalles. Por favor ingrese algun detalle' }
        format.json { head :no_content }
      end
      if result.to_i == 4
        format.html { redirect_to new_invoice_path, notice: 'Error al intentar guardar la factura, por favor vuelva a intentar guardar' }
        format.json { head :no_content }
      end
    end
  end

  # PUT /invoices/1
  # PUT /invoices/1.json
  #def update
  #  @invoice = Invoice.find(params[:id])

  #  respond_to do |format|
  #   if @invoice.update_attributes(params[:invoice])
  #     format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
  #      format.json { head :no_content }
  #    else
  #      format.html { render action: "edit" }
  #      format.json { render json: @invoice.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      if @invoice.nil?
         format.html { redirect_to invoices_url, notice: "No existe esta factura." }
         format.json { head :no_content }  
      end
      result = @invoice.delete_invoice(@invoice)
      if result.to_i == 0
        format.html { redirect_to invoices_url, notice: "La factura ha sido eliminada correctamente." }
        format.json { head :no_content }  
      end
      if result.to_i == 1
        format.html { redirect_to invoices_url, notice: "La factura no puede ser eliminada porque ya ha sido cobrada." }
        format.json { head :no_content }
      end
      if result.to_i == 2
        format.html { redirect_to invoices_url, notice: "Esta factura no puede ser eliminada, ya ha sido procesada" }
        format.json { head :no_content }
      end
    end
  end
  
 # Metodo que agrega los detalles de la factura
  def add_detail
    retire_note = params[:retire_note]
    customer = params[:customer]
    valid_retire_note=/^\d+$/.match(retire_note)
    valid_customer=/^\d+$/.match(customer)
      if(!valid_retire_note.nil? && !valid_customer.nil?) 
        customer = Customer.find(customer)
        if !customer.nil?
          selected_retire_note = RetireNote.where(number: retire_note, customer_id: customer).first
          if !selected_retire_note.nil? && !$details.include?(selected_retire_note)
            $details << selected_retire_note
          end
        end
      end
      ## responde usando ajax 
      respond_to do |format|
        format.js
      end
  end
  ## Retoran el monto total de la factura
  def getTotal
    total = 0
    $details.each do |detail|
      total+=(detail.unit_price * detail.amount)
    end
    respond_to do |format|
      format.html 
      format.json { render json: total.to_i}
    end
  end
  
  ## Retorna el iva 10% sobre el monto 
  ## Retoran el monto total de la factura
  def getTotalIva10
    total = 0
    $details.each do |detail|
      total+=(detail.unit_price / 10)
    end
    respond_to do |format|
      format.html 
      format.json { render json: total.to_i}
    end
  end
  
  # Este metodo permite eliminar de la lista de detalles un detalle seleccionado
  def delete_detail
    retire_note = RetireNote.find(params[:id])
    if $details.include?(retire_note)
      $details.delete(retire_note)
    end
    respond_to do |format|
      format.js
    end
  end
  
  #Este metodo permite hacer busquedas de Factura teniendo en cuenta
  #los paramteros obtenidos del lado del usuario
  def search
    @invoices = Array.new
    datefrom = params[:start_date]
    dateto = params[:end_date]
    number = params[:number]
    customer_id = params[:customer_id]
    invoice_state = params[:invoice_state]
    #Verifico que se hayan ingresados los rangos de fechas de registros para realizar la busqueda
    valid_start_date=/[0-9]{2}-[0-9]{2}-[0-9]{4}/.match(datefrom)
    valid_end_date=/[0-9]{2}-[0-9]{2}-[0-9]{4}/.match(dateto)
    puts datefrom
    begin
      if !valid_start_date.nil? and !valid_end_date.nil?
        @sql = " date between '" + datefrom + "' and '" + dateto + "' "
        
        valid_number= /^\s*[0-9]+-[0-9]+\s+[0-9]+\s*$/.match(number)
        if !valid_number.nil? then 
          @sql = @sql + " and number='" + valid_number.to_s.strip + "'" 
        end
       
        valid_customer_id=/^\d+$/.match(customer_id)
        if !valid_customer_id.nil? then @sql = @sql + " and customer_id=" + customer_id end
        
        if !invoice_state.blank? then @sql = @sql + " and invoice_state = '" + invoice_state + "'" end
         
        @invoices = Invoice.where(@sql)
        if @invoices.empty?
          @invoices = Array.new
        end
          
      end
    rescue
      @invoices = Array.new
      flash[:notice]="Error al buscar facturas."
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  # Metodo que redirecciona a la pagina para declarar los cobros de la factura
  def declare_invoice
    @invoice = Invoice.new
    @invoices = Invoice.where(invoice_state: "No")
    respond_to do |format|
      format.html # declare_invoice.html.erb
      format.json { render json: @invoice }
    end
  end
  
  # Metodo que cambia el estado de la factura a facturado = Si o facturado = Una parte
  def change_invoice_state
    new_invoice_state = params[:invoice_state]
    invoice_number = params[:number]
    @invoice = Invoice.new
    respond_to do |format|
      result = @invoice.change_state(invoice_number,new_invoice_state)
      if result.to_i == 0
        format.html { redirect_to declare_invoice_invoices_path, notice: 'El estado de la factura ha sido actualizado.' }
        format.json {  head :no_content }
        
      end
      if result.to_i == 1
        format.html { redirect_to declare_invoice_invoices_path, notice: 'No se pudo actualizar el estado de la factura. El numero ingresado no es correcto' }
        format.json { head :no_content }
      end
      if result.to_i == 2
        format.html { redirect_to declare_invoice_invoices_path, notice: 'No se pudo actualizar el estado de la factura. No existe el estado ingresado' }
        format.json { head :no_content }
      end
      if result.to_i == 3
        format.html { redirect_to declare_invoice_invoices_path, notice: 'No existe factura con el numero ingresado, por favor verifique el numero ingresado' }
        format.json { head :no_content }
        
      end
      if result.to_i == 4
        format.html { redirect_to declare_invoice_invoices_path, notice: 'Error al intentar actualizar la factura, por favor vuelva a intentar en unos minutos' }
        format.json { head :no_content }
      end
    end
  end
end
