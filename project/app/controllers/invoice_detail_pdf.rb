class InvoiceDetailPdf< Prawn::Document
  def initialize(invoice,details)
    super()
    stroke_color '0B3861'
    line_width 2
    
    #    move_cursor_to 20
    stroke_rectangle [0, 750], 550, 30
    
    draw_text "   Detalles del Servicio" ,:at => [180  , 730]
    move_down 20  
    text "Factura Nro: #{invoice.number}"
    text "Cliente: #{invoice.customer.company_name + ' ' + invoice.customer.last_name + ' ' + invoice.customer.name}"
    @invoice_details=details.collect{|detail| 
      [detail.retire_note.date,detail.retire_note.service_type.description,detail.retire_note.amount,
        detail.retire_note.unit_price.to_i,(detail.retire_note.unit_price / 10).to_i,
       detail.retire_note.product_type.description,detail.retire_note.city.name,detail.retire_note.number,detail.sub_total]
    }
    header_data=[["Fecha","Servicio","Cant","Monto","Iva 10%","Tipo de Producto", "Destino","Nota Retiro", "Sub Total"]]
    table(header_data.concat(@invoice_details),:header => true,:cell_style => { :font => "Helvetica", :size => 10,:border_width => 0})  do
       row(0).font_style = :bold
    end
    move_down 20
    text "Total Gs: #{invoice.total.to_i}"
 end
end