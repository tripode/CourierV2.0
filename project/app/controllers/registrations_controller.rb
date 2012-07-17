class RegistrationsController < Devise::RegistrationsController
 #
  # Antes de hacer cualquier cosa con este controler,
  # se verifica si hay permiso para el usuario logueado
  #
  before_filter :login_require
  skip_before_filter :require_no_authentication
  #
  # Llama a este metodo y verifica los permisos que tiene para User
  #
  def check_permissions
    authorize! :create, User
  end
  
  def login_require
    begin
      current_user
      check_permissions
    rescue
      redirect_to new_user_session_path
    end
  end
  
#  skip_before_filter :login_required, :authorize
#  before_filter :login_required, :authorize
  
  layout "application" 
    #
    # This override the new method, it's for sign_up path, 
    # if exist a user on session it permit access to sign_up;
    # redirect to root_path otherwise.
    #
    def new
      if(params[:messages])
        @messages = params[:messages]
      end
      if current_user
        @employees = Employee.all
        super
      else
        redirect_to root_path
      end
    end

 
 def create
   user = User.find_by_email params[:user][:email]
   user2 = User.find_by_username(params[:user][:username])
    build_resource
    resource.employee_id = params[:employee_id]
    if !user and !user2 and resource.save
      logger.info("Usuario creado: #{resource.username}, #{Time.now}")
      @message = {:success => "El nuevo usuario fue creado exitosamente"}
      redirect_to new_user_registration_path(:messages => @message)
    else
      logger.error("No se pudo crear el usuario #{resource.username}, #{Time.now}")
      redirect_to new_user_registration_path(:messages => {:error => 'No se pudo guardar el usuario'})
    end
  end
  #def create
  # super
  #end

  def update
    super
  end
  
  #
  # This action controller delete a user.
  #
  def delete_user
    Rails.logger = Logger.new(STDOUT)
    puts params.to_yaml
    logger.info params.to_yaml
    if(current_user.id.to_s != params[:id].to_s and params[:id].to_s!=1.to_s)
      @deleted_user = User.find(params[:id])
      begin
        @deleted_user.destroy
        @messages = {:success => "El usuario fue eliminado exitosamente"}
        logger.info("#{@deleted_user.inspect} fue borrado por #{current_user.inspect}, #{Time.now}")
      rescue Exception => e
        logger.error("Error al intentar borrar el usuario #{@deleted_user.inspect}. Excepcion: #{e}, #{Time.now}")
        @messages = {:error => "Hubo un error al intentar eliminar el usuario"}
      end
    else
      @messages = {:alert => "No se puede eliminar este usuario"}
    end
    redirect_to new_user_registration_path(:messages => @messages)
  end

  protected
  
  
  def after_sign_up_path_for(resource)
    new_user_registration_path
  end 
  
  def edit
    super
  end
  
end 