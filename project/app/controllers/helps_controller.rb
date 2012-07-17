class HelpsController < ApplicationController
  
  def index
    @link = [
      "Como crear Usuarios?",
      "Manejo Perfiles","Logout",
      "Como crear Zonas?",
      "Como cargar Ciudades?",
      "Como registrar Clientes por Persona?",
      "Como registrar Clientes por empresa?",
      "Como registrar Destinatarios?",
      "Como registrar Funcionarios?",
      "Como crear nota de retiro",
      "Buscar notas de retiro",
      "Como Registrar productos?",
      "Buscar productos",
      "Como Crear hoja de ruta?",
      "Buscar hoja de ruta",
      "Cargar informe del repartidor",
      "Como Crear guia de transporte?","Buscar guia de transporte",
      "Como Crear manifiesto de carga?","Listar manifiesto de carga"
    ]
    @link_helps=[
      "Vaya al menu de arriba, luego Administracion y luego click en usuarios, Necesita permiso de administrador para crear usuarios",
      "Vaya al menu, esquina derecha superior click un icono con forma de tuerca. Podra editar su password y cambiar su nombre de usuario",
      "Vaya al menu, esquina superior derecha click en el icono que tiene una flecha apuntando a la derecha con un semi cuadrado envolviendolo",
      "Vaya al menu, Registro varios, luego click en Zonas, En ese mismo lugar podra Crear nuevas Areas/zonas ",
      "Vaya al menu, Registro varios, luego click en Ciudades, Podra asignar una ciudad/pueblo/distrito a un departamento del pais (Paraguay)",
      "Vaya al menu, Registro Varios, luego Clientes, click en Clientes por Persona, alli podra crear borrar o editar un clinte de tipo persona (persona fisica)",
      "Vaya al menu, Registro Varios, luego Clientes, click en Clientes por Empresa, alli podra crear borrar o editar un clinte de tipo Empresa (persona juridica)",
      "Vaya al menu, Registro Varios, luego click en Destinatarios, aqui podras crear, editar  y borrar posibles destinatarios de paquetes, ademas de poder asignar varias direcciones a un mismo destinatario",
      "Vaya al menu, Registro Varios, y click en Funcionario, Aqui podras crear, editar y borrar todos tus posibles empleados, necestas tener permisos de Administrador para poder hacerlo",
      "Vaya al menu, Notas, luego click Notas de Retiro, Crear Nota de Retiro, aqui tendras que ingresar todos los datos que corresponden a Una nota de Retiro, podras editar , crear y borrar Notas de Retiro, tambine necesitas permisos especiales para manipular notas de retiro",
      "Vaya al menu, Notas, luego click en Buscar Nota de Retiro, aqui podras buscar notas de retiro ya cargadas de acuerdo a alguien campo, ya sea dentro de unr rago de fechas,  numero  o cliente, o etc. , o talvez una combinacion de todos varios campos",
      "Vaya el menu, Notas, Productos y luego click en Registrar Productos, alli Debes ingresar primero el numero  de Nota de Retiro, se te setearon campos comunes de todos los registros, luego ingresar item por item,  un detinatario y elijiendo una direccion del destinatario, luego debes cargar si o si el numero del codigo de barra",
      "Vaya al menu, Notas, Productos, y luego click en Buscar Productos, alli debes completar algunos campos y realizara las busqueda de cuerdo a los campos completados",
      "Vaya al menu, Notas, Hoja de Ruta, luego click Crear Hoja de Ruta, Aca solo debes ingresar algun comentario de crees necesario, luego elejir una zona/area y luego ir elejiendo los productos mediante el codigo de barra de los mismos y luego darle click en el icono mas de color verda para agregar a la hoja de ruta",
      "Vaya al menu, Notas, Hoja de Ruta, luego click Buscar Hoja de Ruta, debe completar algun/os campos de acuerdo a que estas buscando, realizara la busqueda de acuerdo a esos campos",
      "Vaya al menu, Notas, Hoja de Ruta, luego click Cargar Informe del Repartirdor, Debes ingresar primeramente el numero de la Hoja de Ruta  y luego dar listar, en el deberas cargar el nombre de la persona que recibio el producto, y si no se entrego debes seleccionar el motivo de porque no se entrego",
      "Vaya al menu, Notas, Guia de Transporte, luego click Crear Guia, Debes completar obligatoriamente los campo numero de guia, origen, Empresa/cliente, Destino, Empresa (terciarizada), tambien que tipo de servicio es, y la forma de pago, debes ingresar por lo menos un producto, si no te dara un error al guardar ",
      "Vaya al menu, Notas, Guia de Transporte, luego click Buscar Guia, debes cargar algun campo de la pagina o combinacion de varios para obtener la/s guia/s que estas buscando",
      "Vaya al menu, Notas, Manifiesto de Carga, luego click Crear Manifiesto, el numero es automatico, debes elegir un origen y un destino luego darle click a Generar, te traera todas las Guias de Transporte que cumplan con el el origen y el destino dado, y que su estado se 'En Proceso' , luego puedes seleccionar cuales guias no utilzaras, una vez creada un manifiesto todas las guias cambiaran sus estado a 'Procesado' y automaticamente de Genera un informe para imprimir en pdf",
      "Vaya al menu, Notas, Manifiesto de Carga, luego click en Listar Manifiesto, lista todos los Manifesto creados (Proximamente se cambiara a un Buscar Manifiesto como las demas interfaces) "
    ]
  end
  
end
