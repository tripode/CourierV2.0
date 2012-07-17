PaymentMethod.transaction do
  PaymentMethod.create(:name_payment =>"Contado", :description => "Se paga en efectivo al contado" )
  PaymentMethod.create(:name_payment =>"Credito", :description => "Financiado" )
  PaymentMethod.create(:name_payment =>"Destino", :description => "Se paga cuando se entrega en otra ciudad" )
end