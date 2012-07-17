class UpdateConstraintsProducts < ActiveRecord::Migration
  def up
    

    add_foreign_key :products , :product_types
    add_foreign_key :products , :retire_notes
    add_foreign_key :products , :product_states
    add_foreign_key :products , :receivers  
    

  end

  def down
  end
end
