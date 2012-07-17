module CargoManifestsHelper
  #busca todos los detalles que corresponde al id de la guia de tranposrte dado
  def get_tg_details(transport_guide_id)
    tgd = TransportGuideDetail.where(transport_guide_id: transport_guide_id)
    tgd #retorna detalle de guia de transporte
  end

  #Ayuda a setear los totales que se indica abajo de la interfaz
  #Total de Guias, Total de Piezas, Total de Peso
  #Su parametro es una lista de guias de tranporte, la cual se muestra en la interfaz
  #retorna un arreglo donde la posicion 1 es el weight (peso total)
  #la posicion 2 es el products(cant de productos total)
  #la posicion 0 es la cantidad de guias que en la lista de guias
  #
   def get_totals(transport_guides)
    data = Array.new(3)
    data[0] = transport_guides.length
    products=0
    weight=0
    #no me gusta esto
    transport_guides.each do |guide|
      transport_guides_details = TransportGuideDetail.where(transport_guide_id: guide.id)
      
      transport_guides_details.each do |tgd|
          weight+=tgd.weight
          products+=tgd.amount
      end
    end
    data[1]=weight
    data[2]=products
    data

  end
end
