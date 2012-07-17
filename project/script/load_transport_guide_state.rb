TransportGuideState.transaction do
  TransportGuideState.create(:name_state=> "En Espera",
      :description=> "Cuando la Guia de tranporte aun no ha sido enviada"
  )

  TransportGuideState.create(:name_state=> "Enviado",
      :description=> "Cuando la Guia de tranporte ha sido enviada"
  )

  TransportGuideState.create(:name_state=> "Cancelado",
      :description=> "La GT fue cancelado su envio por algun error en el documento o por el cliente"
  )
  TransportGuideState.create(:name_state=> "Perdido",
      :description=> "La GT fue extraviada por algun motivo"
  )
end
