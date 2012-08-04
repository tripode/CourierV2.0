class CustomLogger
  
  def self.debug(message)
    write_into_log_file("DEBUG", message)
  end
  
  def self.info(message)
    write_into_log_file("INFO", message)
  end
  
  
  def self.warm(message)
    write_into_log_file("WARM", message)
  end
  
  def self.error(message)
    write_into_log_file("ERROR", message)
  end
  
  
  def self.fatal(message)
    write_into_log_file("FATAL", message)
  end
  
  
  protected
  
  def self.write_into_log_file(level, message)
    time      = Time.now
    today     = time.to_date
    file_name = "log/#{today}.log"
    file      = File.open(file_name,"a")
#    -- 2012-07-30 21:32:41.958 -- INFO -- Started DELETE "/users/sign_out" for 127.0.0.1 at 2012-07-30 21:32:41 -0400 -- pid:6932] -- 
    file.puts(" -- #{time} -- #{level} -- #{message} -- \n")
    file.close
  end
end