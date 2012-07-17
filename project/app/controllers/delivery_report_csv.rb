require "csv"
class DeliveryReportCsv
  def initialize(product_type,customer,employee,details, file_path, month, year)
   $csv_string = CSV.generate do |csv|  
        # header row 
          csv << ["Informe de Entrega"]
          csv << ["DS Representaciones"]
          csv << ["Cliente: #{customer.last_name + ' ' + customer.name + ' ' + customer.company_name }"]
          csv << ["Elaborado por:" + employee.last_name + " "+ employee.name]
          csv << ["Tipo de producto:" + product_type]
          csv << ["Mes de: #{month} de #{year}"]
          csv << ["Item;Codigo;Destinatario;Direccion;Recibido por;Devuelto por motivo;Fecha"] 
          # data rows 
          
          details.collect do |detail| 
            item=(details.index(detail) + 1).to_s
            code=detail.product.bar_code
            name=if detail.product.receiver_id != nil then detail.product.receiver.receiver_name else "" end
            address=if detail.product.receiver_address_id!= nil then detail.product.receiver_address.address else "" end
            who= if detail.who_received!= nil then detail.who_received  else "" end
            reason= if detail.reason_id!= nil then detail.reason.description  else "" end
            date=  if !detail.product.received_at.nil? then detail.product.received_at.strftime("%d-%m-%Y") else if !RoutingSheet.where(id: detail.routing_sheet_id).first.nil? then RoutingSheet.where(id: detail.routing_sheet_id).first.date.strftime("%d-%m-%Y") end end 
            new_row=item + ";" + code + ";"  + name + ";" + address + ";" + who + ";" + reason + ";" + date
            csv << [new_row]
          end
        end
  end
  public
  def getCSV
    return $csv_string
  end
end