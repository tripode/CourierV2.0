class CargoManifestReportPdf < Prawn::Document

  def initialize(create_date,employee,cargo_manifest)
    super()
    stroke_color '0B3861'
    line_width 2
    
    #    move_cursor_to 20
    stroke_rectangle [0, 750], 550, 30
    draw_text "  Manifiesto de Carga - DS Representaciones" ,:at => [180  , 730]
    move_down 20
    text "  Empleado:#{employee.name  + ' ' + employee.last_name}"
    text "Manifiesto Numero: #{cargo_manifest.manifest_num}"
    origin_city= City.find(cargo_manifest.origin_city_id).name
    destiny_city= City.find(cargo_manifest.destiny_city_id).name
    text "  Trayecto: #{origin_city} - #{destiny_city}"
    text "  Fecha de creacion: #{create_date}"
    move_down 10
    cargo_manifest_detail = CargoManifestDetail.where(cargo_manifest_id: cargo_manifest.id);
    cont =0
    total_amount=0
    total_weight=0
    @cargo_manifest_details= Array.new
    cargo_manifest_detail.each{|d|
      tg = TransportGuide.find(d.transport_guide_id)
      tg_detail= TransportGuideDetail.where(transport_guide_id: tg.id)
      if tg_detail.empty?
        raise "No se puede generar pdf de GT sin detalles"
      end
      inner_table= Array.new
      index=0
      tg_detail.each { |e|
        inner_table[index]=[{:content => e.product_type.description, :width => 200},
          e.amount,
          e.weight]
        index+=1
        total_amount+=e.amount
        total_weight+=e.weight

      }
      #      sub_header_data=[["Producto","Cantidad","Peso"]]
      sub_table=nil
      sub_table=make_table(inner_table) 
      
        

      @cargo_manifest_details[cont]=[ cargo_manifest_detail.index(d) + 1,
        tg.remitter_person,
        tg.destination_person,
        tg.customer.company_name,
        sub_table
      ]
      cont+=1
    }
    
    header_data=[["N#","Remitente","Destinatario","Cliente",{:content => "Producto (cant/peso 'kg')", :width => 200}]]
    stroke_color 'ffffff'
    table(header_data+@cargo_manifest_details) do
      cells.padding = 12
      cells.borders = []
      row(0).borders = [:bottom]
      row(0).border_width = 2
      row(0).font_style = :bold
      columns(0..3).borders = [:right]
      row(0).columns(0..3).borders = [:bottom, :right]
      cells.borders = [:bottom]
    end
    move_down 20

    text "Cantidad total de items: #{total_amount} #{ (total_amount>1) ? "items" : "item"} "
    text "Peso total de la carga: #{total_weight} kg "
    move_down 60
    text "Fecha de recepcion: _____________________"
    move_down 20
    text "Hora de recepcion: ____________________"
    move_down 20
    text "Recibido por: _________________________   Numero de Cedula: _____________________ "
    move_down 20
    text "Entregado por: _________________________    Numero de Cedula: _____________________ "



    #    text "<u><link href='#{url_new}'>Nuevo reporte</link></u>  <u><link href='#{root_url}main_page/index'>Cancelar</link></u> ", :inline_format => true
  end

end
