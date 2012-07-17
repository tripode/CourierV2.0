require 'date'
Employee.transaction do
    date= Time.now 
    Employee.create(
        :email=>"setwildo31@gmail.com",
        :name=>"Wildo",
        :last_name =>"Monges",
        :num_identity => 1,
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