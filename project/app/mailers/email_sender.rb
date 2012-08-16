class EmailSender < ActionMailer::Base
  default from: "ds.representaciones.py@gmail.com"
  
  ##
  # Este metodo es el encargado de preparar los destinatarios, asunto y adjuntos.
  #
  def eemail(email, file_name, report_date, pdf) 
    puts email
    month_number = Date.parse(report_date).month
    year = Date.parse(report_date).year
    months = {
      1 => 'Enero', 2 => 'Febrero', 3 => 'Marzo', 4 => 'Abril',
      5 => 'Mayo', 6 => 'Junio', 7 => 'Julio', 8 => 'Agosto',
      9 => 'Septiembre', 10 => 'Octubre', 11 => 'Noviembre', 12 => 'Diciembre'}
    month = months[month_number]
    attachments[file_name] = pdf.render
    mail(:to => email, :subject => "Informe #{month} de #{year}") do |format|
      format.text do
        render :text => 'DS Representaciones agradece la preferencia. Por seguridad confirme la recepcion de este email. Gracias.'
      end
    end 
  end
  
  
end
