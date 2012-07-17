RoutingSheetState.transaction do
  RoutingSheetState.create(:state_name => "En Proceso", :description => "Actualmente entregando los productos de esta hoja de ruta")
  RoutingSheetState.create(:state_name => "Procesado", :description => "Los productos de la hoja de ruta fueron entregados")
  RoutingSheetState.create(:state_name => "Cancelado", :description => "La hoja de ruta ha sido cancelada")
end