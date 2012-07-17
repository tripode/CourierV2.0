class CreateRoutingSheetStates < ActiveRecord::Migration
  def change
    create_table :routing_sheet_states do |t|
      t.string :state_name, :null=>false, :limit=>50
      t.string :description, :limit=>100
    end
  end
end
