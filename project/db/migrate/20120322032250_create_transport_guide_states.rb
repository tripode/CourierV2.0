class CreateTransportGuideStates < ActiveRecord::Migration
  def change
    create_table :transport_guide_states do |t|
      t.string :name_state , :limit=>40, :null =>false
      t.string :description, :limit=>100

    end
  end
end
