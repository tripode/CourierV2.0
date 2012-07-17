class AddUnitCostToTransportGuideDetail < ActiveRecord::Migration
  def change
    add_column :transport_guide_details, :unit_cost, :decimal, :null=>false

  end
end
