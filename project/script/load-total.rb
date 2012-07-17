#si van a crear otra tabla, aca datos agreguenle aca y creen un archivo
#llamado load_xxxx.rb xxxx es el nombre del modelado que crearon
#asi no borramos todos los datos y volvemos a correr load-total y solo corremos
# la que necesitamos. recuerden que este archivo solo espara bd completamente
#vacias osea bd nuevas

FunctionType.transaction do

    FunctionType.create(:description=>"Administrador")
    FunctionType.create(:description=>"Mensajero")
    FunctionType.create(:description=>"Secretaria")

end
CustomerType.transaction do
  CustomerType.create(:type_name=>"Empresa")
  CustomerType.create(:type_name=>"Persona")

end

require 'date'
Employee.transaction do
    date= Time.now 
    Employee.create(
        :email=>"tripodevs@googlegroups.com",
        :name=>"Tripodevs",
        :last_name =>"Tripodevs",
        :num_identity => 0000001,
        :address=>"Encarnacion",
        :admission_date=>date,
        :birthday=>date,
        :salary=>0,
        :mobile_number=>"(xxxx)xxxxxx",
        :phone_number=>"(xxx)xxxxxx",
        :function_type_id=>1
     )
    Employee.create(
        :email=>"setwildo31@gmail.com",
        :name=>"Wildo",
        :last_name =>"Monges",
        :num_identity => 3539120,
        :address=>"Barrio Kennedy",
        :admission_date=>date,
        :birthday=>date,
        :salary=>0,
        :mobile_number=>"(0985)163420",
        :phone_number=>"(071)207865",
        :function_type_id=>1
     )
    Employee.create(
        :email=>"diego.courier@gmail.com",
        :name=>"Diego",
        :last_name =>"Silvero",
        :num_identity => 2,
        :address=>"Barrio Arroyo Pora",
        :admission_date=>date,
        :birthday=>date,
        :salary=>1650000,
        :mobile_number=>"(0985)741172",
        :phone_number=>nil,
        :function_type_id=>1
      )
end

PaymentMethod.transaction do
  PaymentMethod.create(:name_payment =>"Contado", :description => "Se paga en efectivo al contado" )
  PaymentMethod.create(:name_payment =>"Credito", :description => "Financiado" )
  PaymentMethod.create(:name_payment =>"Destino", :description => "Se paga cuando se entrega en otra ciudad" )
end
ProductState.transaction do

    ProductState.create(:state_name=>"Enviado", 
                        :description=>"Producto en proceso de hoja de ruta para su entrega")
    ProductState.create(:state_name=>"No enviado", 
                        :description=>"El producto no se ruteo todavia")
    ProductState.create(:state_name=>"De vuelto", 
                        :description=>"Son los productos cancelados a pedido del cliente y devueltos")
    ProductState.create(:state_name=>"Extraviado", 
                        :description=>"Productos perdidos en el proceso de envio")
    ProductState.create(:state_name=>"Recibido", 
                        :description=>"Producto que se entrego al destinatario")                     
    ProductState.create(:state_name=>"No Recibido", 
                        :description=>"Producto que no fue recibido por ninguna persona en la direccion dada")
    ProductState.create(:state_name=>"Pendiente", 
                        :description=>"Producto que debe volver a ser ruteado por no ser entregado")
    

end
ProductType.transaction do

    ProductType.create(:description=>"Sobre")
    ProductType.create(:description=>"Factura")
    ProductType.create(:description=>"Pin")
    ProductType.create(:description=>"Chequera")
    ProductType.create(:description=>"Malote")
    ProductType.create(:description=>"Caja")
    ProductType.create(:description=>"Paquete")
    ProductType.create(:description=>"Extracto de Tarjeta Credito")
    ProductType.create(:description=>"Extracto de Cuenta Corriente")
    ProductType.create(:description=>"Tarjeta de Credito/Debito")
    ProductType.create(:description=>"Documentos Varios")

end
Reason.transaction do
    
#    Reason.create(:description=>"Se mudó")
#    Reason.create(:description=>"No atiende nadie en el lugar")
#    Reason.create(:description=>"No existe Nº de casa")
#    Reason.create(:description=>"Falta Nº de casa")
#    Reason.create(:description=>"No quiere recibir")
#    Reason.create(:description=>"Se trasladó")
#    Reason.create(:description=>"Cerrado en hora de reparto")
#    Reason.create(:description=>"Falta Nº de Piso/Oficina/Dpto.")
#    Reason.create(:description=>"Ya no trabaja en el lugar")
#    Reason.create(:description=>"De vacaciones")
#    Reason.create(:description=>"De reposo")
#    Reason.create(:description=>"Casa en refacción/Casa Desocupada")
#    Reason.create(:description=>"Falta Nº de local/Bloque")
#    Reason.create(:description=>"Producto extraviado en el reparto")
#    Reason.create(:description=>"Producto cancelado a pedido del cliente")
#    Reason.create(:description=>"Otros")
    Reason.create(:description=>"Casa vacia / En construcción")
    Reason.create(:description=>"Dirección incompleta")
    Reason.create(:description=>"Esta de viaje")
    Reason.create(:description=>"Esta fuera del pais")
    Reason.create(:description=>"Falleció")
    Reason.create(:description=>"Faltan datos")
    Reason.create(:description=>"No desea / Ya cancelo")
    Reason.create(:description=>"No lo conocen en lugar de visita")
    Reason.create(:description=>"No se ubica al titular")
    Reason.create(:description=>"No se ubica la dirección")
    Reason.create(:description=>"No trabaja mas en el lugar de visita")
    Reason.create(:description=>"Numero inexistente")
    Reason.create(:description=>"Retira de entidad emisora")
    Reason.create(:description=>"Producto extraviado en el reparto")
    Reason.create(:description=>"Producto cancelado a pedido del cliente")
    Reason.create(:description=>"Retira del courier")
    Reason.create(:description=>"Se mudo")
    Reason.create(:description=>"Sin cobertura")
    Reason.create(:description=>"De vacaciones")
    Reason.create(:description=>"No contesta llamada")
    Reason.create(:description=>"Teléfono ocupado")
    Reason.create(:description=>"Teléfono tono fax")
    Reason.create(:description=>"No corresponde a destinatario")
    Reason.create(:description=>"Contestador automatico")
    Reason.create(:description=>"No sabe explicar dirección")
    Reason.create(:description=>"Se ubica solo por la noche")
    Reason.create(:description=>"No quiere que se le llame")
    Reason.create(:description=>"Va a llamar")

end
ServiceType.transaction do
  ServiceType.create(:description=> "Urbano")
  ServiceType.create(:description=> "Nacional")
end
TransportGuideState.transaction do
  TransportGuideState.create(:name_state=> "En Proceso",
      :description=> "Cuando la GT  fue creado y aun no fue cargado a un manifiesto de carga"
  )

  TransportGuideState.create(:name_state=> "Procesado",
      :description=> "Cuando la GT fua anexada a un manifiesto de carga"
  )

  TransportGuideState.create(:name_state=> "Cancelado",
      :description=> "La GT fue cancelado su envio por algun error en el documento o por el cliente"
  )
  TransportGuideState.create(:name_state=> "Perdido",
      :description=> "La GT fue extraviada por algun motivo"
  )
end
Country.transaction do
  Country.create(:name => "Paraguay", :description => "Su capital es Asunción")
  Country.create(:name => "Brasil", :description => "Su capital es Brasilia")
  Country.create(:name => "Argentina", :description => "Su capital es Buenos Aires")
  Country.create(:name => "Uruguay", :description => "Su capital es Montevideo")
  Country.create(:name => "Bolivia", :description => "Su capital es La Paz")
end
Province.transaction do
   ## Provincias de Paraguay
  Province.create(:name => "Concepcion", :description => "Su capital es Concepcion", :country_id=> 1)
  Province.create(:name => "San Pedro", :description => "Su capital es San Pedro", :country_id=> 1)
  Province.create(:name => "Cordillera", :description => "Su capital es Caacupe", :country_id=> 1)
  Province.create(:name => "Caaguazu", :description => "Su capital es Coronel Oviedo", :country_id=> 1)
  Province.create(:name => "Guaira", :description => "Su capital es Villarrica", :country_id=> 1)
  Province.create(:name => "Caazapa", :description => "Su capital es Caazapa", :country_id=> 1)
  Province.create(:name => "Itapua", :description => "Su capital es Encarnacion", :country_id=> 1)
  Province.create(:name => "Misiones Py", :description => "Su capital es San Juan Bautista", :country_id=> 1)
  Province.create(:name => "Paraguari", :description => "Su capital es Paraguari", :country_id=> 1)
  Province.create(:name => "Alto Parana", :description => "Su capital es Alto Parana", :country_id=> 1)
  Province.create(:name => "Central", :description => "Su capital es Aregua", :country_id=> 1)
  Province.create(:name => "Neembucu", :description => "Su capital es Pilar", :country_id=> 1)
  Province.create(:name => "Amambay ", :description => "Su capital es Pedro Juan Caballero", :country_id=> 1)
  Province.create(:name => "Canindeyu", :description => "Su capital es Villa Hayes", :country_id=> 1)
  Province.create(:name => "Presidente Hayes", :description => "Su capital es Caazapa", :country_id=> 1)
  Province.create(:name => "Alto Paraguay", :description => "Su capital es Fuerte Olimpo", :country_id=> 1)
  Province.create(:name => "Boqueron", :description => "Su capital es Filadelfia", :country_id=> 1)
  
  ##Provincias de Argentina
  Province.create(:name => "Misiones Arg", :description => "Su capital es Posadas", :country_id=> 3)
end


RetireNoteState.transaction do
  RetireNoteState.create(:state_name => "Procesado")
  RetireNoteState.create(:state_name => "En Proceso")
  RetireNoteState.create(:state_name => "Cancelado")
end
Role.transaction do

    Role.create(:name=> "Administrador")
    Role.create(:name=> "Repartidor")
    Role.create(:name=> "Secretaria")

end
User.transaction do
    ## User por defecto para entrar al sistema
    User.create(:username     => 'tripodevs',
                :email        => 'tripodevs@googletroups.com',
                :password     => 'tripodevs',
                :employee_id  => 1,
                :role_ids     => Role.where(:name => 'Administrador').first.id
               )
    User.create(:username     => 'admin',
                :email        => 'admin@admin.com',
                :password     => 'pass',
                :employee_id  => 2,
                :role_ids     => Role.where(:name => 'Administrador').first.id
               )
    ## User de el dueno de la empresa Diego Silvero
    User.create(:username     => 'diego',
                :email        => 'diego.courier@gmail.com',
                :password     => 'pass',
                :employee_id  => 3,
                :role_ids     => Role.where(:name => 'Administrador').first.id
               )
end
RoutingSheetState.transaction do
  RoutingSheetState.create(:state_name => "En Proceso", :description => "Actualmente entregando los productos de esta hoja de ruta")
  RoutingSheetState.create(:state_name => "Procesado", :description => "Los productos de la hoja de ruta fueron entregados")
  RoutingSheetState.create(:state_name => "Cancelado", :description => "La hoja de ruta ha sido cancelada")
end
#si van a crear otra tabla, aca datos agreguenle aca y creen un archivo
#llamado load_xxxx.rb xxxx es el nombre del modelado que crearon
#asi no borramos todos los datos y volvemos a correr load-total y solo corremos
# la que necesitamos. recuerden que este archivo solo espara bd completamente
#vacias osea bd nuevas


