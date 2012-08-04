require 'custom_logger'

class AuditsController < ApplicationController
  
  def index
    @from  = (!params[:from].nil? and params[:from] != "") ? Date.strptime(params[:from], '%d-%m-%Y').to_time : Time.now
    @to    = (!params[:to].nil?   and params[:to]   != "") ? Date.strptime(params[:to], '%d-%m-%Y').to_time : Time.now
    
    file_name = "#{Rails.env}.log"
    file_dir = "log"
    @objects = Array.new
    counter = 0
    
    @from.to_date.upto(@to.to_date) do |day|
      begin
        File.open("log/#{day}.log","r") do |file|
          while line = file.gets
            array =  line.split(" -- ")
              if array[1].to_s != ""
                begin
                  if Time.parse(array[1].to_s) > (@from-1.day) and Time.parse(array[1].to_s) < (@to+1.day)
                    @objects[counter] = array 
                    counter += 1
                  end
                rescue

                end
              end

          end
        end
      rescue Exception => e
        CustomLogger.info("No hay archivos de log para la fecha: #{day}, Excepcion: #{e}")
      end
    end
      
    @messages = {}
    @messages[:success]="Search from: #{Date::MONTHNAMES[@from.month]} #{@from.day}, #{@from.year} to: #{Date::MONTHNAMES[@to.month]} #{@to.day}, #{@to.year}"
  end
  
end
