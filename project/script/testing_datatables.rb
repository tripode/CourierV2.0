require 'date'
Employee.transaction do
 
  (55..15000).each do |t|
    begin
      @employee = Employee.find(t)
      @employee.destroy
    rescue 
      puts "ERROR"
    
    end
  end

end