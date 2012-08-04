require 'custom_logger'

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  #Para tener acceso a cualquier metodo en el controller 
  # debe haber un user loggeado.
  before_filter :authenticate_user!, :log
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "No tienes permisos para acceder a esta pagina."
    redirect_to root_url
  end

  rescue_from ActiveRecord::RecordNotFound ,  :with => :route_not_found
  rescue_from ActionController::RoutingError, :with => :route_not_found
  rescue_from ActionController::MethodNotAllowed, :with => :invalid_method

  private

  def route_not_found
     redirect_to '/500.html'
  end

  def invalid_method
#    message = "Now, did your mom tell you to #{request.request_method.to_s.upcase} that ?"
#    render :text => message, :status => :method_not_allowed
    flash[:error] = "No tienes permisos para acceder a esta pagina."
    redirect_to root_url
  end
  
  ##
  # Este metodo redirecciona a sign_in 
  # despues de un sign_out
  #
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
  
  ##
  # Log de cada action que se llama
  #
  def log
    begin
      if (user_signed_in?)
        CustomLogger.info("Usuario: #{current_user.email}, Empleado: #{current_user.employee.full_name}, Controller: #{params[:controller]}, Accion: #{params[:action]}")
      else
        CustomLogger.info("Controller: #{params[:controller]}, Action: #{params[:action]}")
      end
    end
  end
  
end
