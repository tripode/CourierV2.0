User.transaction do
    ## User por defecto para entrar al sistema
    User.create(:username     => 'admin',
                :email        => 'admin@admin.com',
                :password     => 'pass',
                :employee_id  => 1,
                :role_ids     => Role.where(:name => 'Administrador').first.id
               )
    ## User de el dueno de la empresa Diego Silvero
    User.create(:username     => 'diego',
                :email        => 'diego.courier@gmail.com',
                :password     => 'pass',
                :employee_id  => 1,
                :role_ids     => Role.where(:name => 'Administrador').first.id
               )
end