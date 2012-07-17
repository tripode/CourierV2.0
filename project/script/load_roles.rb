Role.transaction do

    Role.create(:name=> "Administrador")
    Role.create(:name=> "Repartidor")
    Role.create(:name=> "Secretaria")

end