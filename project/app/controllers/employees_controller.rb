class EmployeesController < ApplicationController
  #
  # Antes de hacer cualquier cosa con este controler,
  # se verifica si hay permiso para el usuario logueado
  #
  before_filter :check_permissions
  skip_before_filter :require_no_authentication
  #
  # Llama a este metodo y verifica los permisos que tiene para Employee
  #
  def check_permissions
    authorize! :create, Employee
  end
  
  #en el metodo index van todos los metodos que apuntan al index
  #El index solo es para listar. Crear un tabla
  # GET /employees
  # GET /employees.json
  def index
    #Para no mostrar el empleado oculto que se usa como superuser en la base de datos y el sistema
    @employees = Employee.where("id != 1")
 
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @employees }
    end
  end

  #cuando queremos mostrar un objeto creado usa el show
  # GET /employees/1
  # GET /employees/1.json
  def show
    @employee = Employee.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @employee }
    end
  end

  #aca van todos los datos necesario para desplegar la ventana new
  #donde se crea un nuevo objeto, luego apunta al create para guardar el objeto
  #
  # GET /employees/new
  # GET /employees/new.json
  def new
    #Para no mostrar el empleado oculto que se usa como superuser en la base de datos y el sistema
    @employees = Employee.where("id != 1")
    @employee = Employee.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @employee }
    end
  end

  # aca se guarda el nuevo objeto editado o actualizado en la ventana edit.html
  # levando por el metodo update
  # GET /employees/1/edit
  def edit
    @employee = Employee.find(params[:id])
    respond_to do |format|
      # format.html { render action: "index" }
      format.js
      # format.json { render json: @employee }
    end
  end
  # cuando estamos le damos crear objeto o guardar en la ventana new.html
  # lanzado por el metodo new, se dispara este metodo par a
  # realizar los procesos de guardado en la bd
  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(params[:employee])

    respond_to do |format|
      if @employee.save
        logger.info("Se crea empleado: #{@employee}, usuario: #{current_user.inspect}, #{Time.now}")
        format.html { redirect_to new_employee_path, notice: 'Empleado Creado Exitosamente!' }
        format.json { render json: @employee, status: :created, location: @employee }
      else
        logger.error("Error al crear empleado: #{@employee}, usuario: #{current_user.inspect}, #{Time.now}")
        format.html { render action: "new" }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # aqui van todo lo necesario para levantar la ventana edit.html
  # cuando le damos guardar objeto o actualizar objeto va al metodo edit
  # PUT /employees/1
  # PUT /employees/1.json
  def update
    @employee = Employee.find(params[:id])

    respond_to do |format|
      if @employee.update_attributes(params[:employee])
        logger.info("Se actualiza empleado: #{@employee}, usuario: #{current_user.inspect}, #{Time.now}")
        format.html { redirect_to new_employee_path, notice: 'Empleado Actualizado Exitosamente!' }
        format.json { head :no_content }
      else
        logger.error("Error al actualizar empleado: #{@employee}, usuario: #{current_user.inspect}, #{Time.now}")
        format.html { render action: "edit" }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # cuando damos delete a un objeto se lanza este metodo 
  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee = Employee.find(params[:id])
    begin
      @employee.destroy
      logger.info("Se borra empleado: #{@employee}, usuario: #{current_user.inspect}, #{Time.now}")
    rescue ActiveRecord::StatementInvalid
      notice= 'Hubo un error'
      logger.error("Error al borrar empleado: #{@employee}, usuario: #{current_user.inspect}, #{Time.now}")
    end
    

    respond_to do |format|
      format.html { redirect_to new_employee_url}
      format.json { head :no_content }
    end
  end
end
