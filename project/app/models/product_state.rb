class ProductState < ActiveRecord::Base
  has_many :products
  
  ENVIADO = 1
  NO_ENVIADO = 2
  DEVUELTO = 3
  EXTRAVIADO = 4
  RECIBIDO = 5
  NO_RECIBIDO = 6
  PENDIENTE = 7
  
  def self.enviado
    return ENVIADO
  end
  
  def self.no_enviado
    return NO_ENVIADO
  end
  
  def self.devuelto
    return DEVUELTO
  end
  
  def self.extraviado
    return EXTRAVIADO
  end
  
  def self.recibido
    return RECIBIDO
  end
  
  def self.no_recibido
    return NO_RECIBIDO
  end
  
  def self.pendiente
    return PENDIENTE
  end
  
  # Estados Utilizados
  # 1 Enviado (Este estado es uando se encuentra en proceso de hoja de ruta)
  # 2 No enviado (Es el estado por defecto al registrarse un producto)
  # 3 Devuelto (Este estado es cuando el producto fue recibido, luego el destinatario lo devuelve a la empresa)
  # 4 Extraviado (Se perdio )
  # 5 Recibido (Producto recibido por el destinatario)
  # 6 No Recibido (Producto no entregado, no recibio el destinatario en horas de reparticion)
  # 7 Pendiente (Producto que deber volver a rutearse porque no se ha entregado)
  def getProductStates
    ProductState.all.collect{|ps|[ps.state_name, ps.id]}
  end
  
  
  
end
