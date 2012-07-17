Customer.transaction do
    #Customer: Companies
    Customer.create(:name=>"", :last_name=>"",:company_name=>"Banco Continental",:ruc=>"123456-0",
                    :address=>"Direccion A",:num_identify=>100, :mobile_number=>"",:phone_number=>"071-201010",
                    :email=>"continental@gmail.com", :customer_type_id=>1)
    Customer.create(:name=>"", :last_name=>"",:company_name=>"Banco Itapua",:ruc=>"123456-1",
                    :address=>"Direccion B",:num_identify=>101, :mobile_number=>"",:phone_number=>"071-201011",
                    :email=>"itapua@gmail.com", :customer_type_id=>1)
    Customer.create(:name=>"", :last_name=>"",:company_name=>"Banco Itau",:ruc=>"123456-2",
                    :address=>"Direccion C",:num_identify=>102, :mobile_number=>"",:phone_number=>"071-201012",
                    :email=>"itau@gmail.com", :customer_type_id=>1)
    Customer.create(:name=>"", :last_name=>"",:company_name=>"Banco BBVA",:ruc=>"123456-3",
                    :address=>"Direccion D",:num_identify=>103, :mobile_number=>"",:phone_number=>"071-201013",
                    :email=>"bbva@gmail.com", :customer_type_id=>1)                
   
   #Customer: Personal
   Customer.create(:name=>"Juan", :last_name=>"Perez",:company_name=>"",:ruc=>"3539111-0",
                    :address=>"Direccion Quiteria",:num_identify=>200, :mobile_number=>"",:phone_number=>"071-201515",
                    :email=>"juan@gmail.com", :customer_type_id=>2)
   Customer.create(:name=>"Guillermo", :last_name=>"Gonzalez",:company_name=>"",:ruc=>"3539144-1",
                    :address=>"Direccion Kennedy",:num_identify=>201, :mobile_number=>"",:phone_number=>"071-201516",
                    :email=>"guillermo@gmail.com", :customer_type_id=>2)

end