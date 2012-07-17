class DeliveryReportPdf< Prawn::Document
  def initialize(product_type,customer,employee,details,url_new, root_url, file_path, month, year)
    super()
    stroke_color '0B3861'
    line_width 2
    
    #    move_cursor_to 20
    stroke_rectangle [0, 750], 550, 30
    
    draw_text "   Informe de Entrega" ,:at => [180  , 730]
    move_down 20
    
    text "DS Representaciones"
    text "Cliente: #{customer.company_name + ' ' + customer.last_name + ' ' + customer.name}"
    text "Elaborado por: #{employee.last_name + ' ' + employee.name}"
    text "Tipo de Producto: #{product_type}"
    text "Mes de: #{month.to_s} de #{year.to_s}"
    move_down 20
   
   
    @routing_sheets_details=details.collect{|detail| 
      [details.index(detail) + 1,
      detail.product.bar_code,
      if !detail.product.receiver_id.nil? then detail.product.receiver.receiver_name end,
      if !detail.product.receiver_address_id.nil? then detail.product.receiver_address.address end,
      detail.who_received,
      if !detail.reason_id.nil? then detail.reason.description end,
      if !detail.product.received_at.nil? then detail.product.received_at.strftime("%d-%m-%Y") else if !RoutingSheet.where(id: detail.routing_sheet_id).first.nil? then RoutingSheet.where(id: detail.routing_sheet_id).first.date.strftime("%d-%m-%Y") end end ]
    }
    header_data=[["Item","Codigo","Destinatario","Direccion","Recibido por","Devuelto por motivo", "Fecha"]]
    table(header_data.concat(@routing_sheets_details),:header => true,:cell_style => { :font => "Helvetica", :size => 10,:border_width => 0},:column_widths => { 0 => 35, 1 => 85, 2 => 85, 3 => 85, 4 => 80, 5 => 80, 6 => 85, 7 => 80})  do
       row(0).font_style = :bold
    end
    move_down 30
    
    #text "<u><a href='#{root_url}products/send_email?customer_id=#{customer.id}&file_path=#{file_path}' method='post'>Enviar</a></u>   <u><link href='#{url_new}'>Nuevo reporte</link></u>  <u><link href='#{root_url}main_page/index'>Cancelar</link></u> ", :inline_format => true
    
    number_pages "Pag:<page>", 
                                         {:start_count_at => 1,
                                          :page_filter => lambda{ |pg| pg != 0 },
                                          :at => [bounds.right - 50, 0],
                                          :align => :right,
                                          :size => 10}
  end
end