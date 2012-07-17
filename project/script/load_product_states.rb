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