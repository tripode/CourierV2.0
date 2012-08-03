class Invoice < ActiveRecord::Base
  has_many :invoice_details
  belongs_to :customer
  belongs_to :payment_method
  
  validates :number,:customer_id,:date, :payment_method_id, :invoice_state, :presence =>true
   #formato de fecha
  def format_date
    created_at= Date.today
    created_at.strftime("%d-%m-%Y") if created_at
  end
  
  #lista todos las formas de pagos disponibles en un select
  def get_list_payments_methods
    PaymentMethod.get_list_payment_methods
  end
  
  # Metodo que se encarga de guardar la factura con sus detelles a la base de datos
  # Retorna true si la factura se guardo correctamente, false en caso contrario
  # Return 0 si se guardo
  # Returm 1 si no se guardo y el numero no es en formato valido de una factura
  # Return 2 si ya existe un numero de factura con el numero ingresado
  # Return 3 si se intenta guardar sin detalles
  # Return 4 si hubo un error en la transaccion al guardar
  def save_invoice(invoice, details)
    number = invoice.number
    valid_number= /^\s*[0-9]+-[0-9]+\s+[0-9]+\s*$/.match(number)
    if valid_number.nil?
      return 1
    end
    exist_invoice = Invoice.where(number: number.strip).first
    # Controla que no exista el numero de factura a guardar
    if !exist_invoice.nil?
      return 2
    end
    #Controla que la factura tenga detalles antes de guardar
    if details.empty?
      return 3
    end
    Invoice.transaction do
      begin
        invoice.invoice_state = INVOICE_NOT_PROCESSED()
        invoice.iva5 = 0
        invoice.save
        total_iva = 0
        total_invoice = 0
        details.each do |retire_note|
          invoice_detail = InvoiceDetail.new
          invoice_detail.retire_note_id = retire_note.id
          invoice_detail.invoice_id = invoice.id
          invoice_detail.sub_total = (retire_note.unit_price * retire_note.amount)
          total_invoice = total_invoice + (retire_note.unit_price * retire_note.amount)
          total_iva = total_iva + (retire_note.unit_price / 10)
          invoice_detail.save
        end
        invoice.update_attribute(:iva10,  total_iva.to_i)
        invoice.update_attribute(:total, total_invoice.to_i)
      rescue
        return 4
      end
      return 0 # Exito al guardar la factura
    end
  end
  #Este metodo cambia el estado de una factura
  def change_state(number,new_state)
    valid_number = /^\s*[0-9]+-[0-9]+\s+[0-9]+\s*$/.match(number.to_s)
    puts valid_number
    if valid_number.nil?
      return 1
    end
    @estados =Array.new
    @estados.push("Si")
    @estados.push("No")
    @estados.push("Una parte")
    if !@estados.include?(new_state)
      return 2
    end
    @invoice = Invoice.where(number: number.strip).first
    if @invoice.nil?
      return 3 
    end
    begin
     @invoice.update_attribute(:invoice_state, new_state.strip)
    rescue
      return 4
    end
    return 0
  end
  
  
  #La factura ya se cobro por completo
  def INVOICE_PROCESSED
    return "Si"
  end
  #La factura todavia  no se ha cobrado
  def INVOICE_NOT_PROCESSED
    return  "No"
  end
  #Se cobro una parte de la factura pero falta parte del monto total
  def INVOICE_PROCESSING
    return "Una parte"
  end
  def getEstados
    @estados =Array.new
    @estados.push("Si")
    @estados.push("No")
    @estados.push("Una parte")
    @estados.collect{|c| c}
  end
  # Este metodo elimina una factura y sus detalles
  # si su estado de facturado es = No
  def delete_invoice(invoice)
    
    # Solo se puede eliminar si el estado es No, caso contrario retornar error
    if invoice.invoice_state.downcase == "si" || invoice.invoice_state.downcase == "una parte"
      return 1
    end
    #Se intenta eliminar cabecera y detalles de la factura dentro de una transaccion
    begin
    Invoice.transaction do
      details = InvoiceDetail.where(invoice_id: invoice.id)
      details.each do |detail|
        detail.destroy
      end
      invoice.destroy
    end
    rescue
      return 2
    end
    return 0 # EXITO AL ELIMINAR LA FACTURA
  end
end
