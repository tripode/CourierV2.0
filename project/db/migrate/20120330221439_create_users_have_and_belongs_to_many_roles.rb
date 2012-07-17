class CreateUsersHaveAndBelongsToManyRoles < ActiveRecord::Migration

  def self.up
    create_table :roles_users, :id => false do |t|
      t.references :role, :user
    end
    
    add_foreign_key :roles_users, :roles
    add_foreign_key :roles_users, :users
    
  end
 
  def self.down
    drop_table :roles_users
  end
  
end
