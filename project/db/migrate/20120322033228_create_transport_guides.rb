class CreateTransportGuides < ActiveRecord::Migration
  def change

    create_table :transport_guides do |t|
      t.string :destination_person, :limit=>60
      t.string :destination_address, :limit=>100
      t.string :remitter_person, :limit=>60
      t.string :remitter_address, :limit=>100
      t.integer :num_guide, :null=>false
      
      t.integer :customer_id, :null=>false
      t.integer :employee_id, :null=>false
      t.integer :service_type_id, :null=>false
      t.integer :transport_guide_state_id, :null=>false
      t.integer :payment_method_id, :null=>false
      
      t.integer :destination_city_id, :null=>false
      t.integer :origin_city_id, :null=>false


    end
    add_foreign_key :transport_guides, :customers
    add_foreign_key :transport_guides, :employees
    add_foreign_key :transport_guides, :service_types
    add_foreign_key :transport_guides, :transport_guide_states
    add_foreign_key :transport_guides, :payment_methods
    
    #el fk destination_city_id se une con cities
    constraint_name = "fk_transport_guides_destination_city_id" 

    execute "alter table transport_guides
              add constraint #{constraint_name}
              foreign key (destination_city_id)
              references cities(id)"
              
    #el fk origin_city_id se une con cities        
    constraint_name2 = "fk_transport_guides_origin_city_id" 

    execute "alter table transport_guides
              add constraint #{constraint_name2}
              foreign key (origin_city_id)
              references cities(id)"
  end
end
