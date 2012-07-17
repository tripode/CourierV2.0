class AddCreatedAtToTransportGuides < ActiveRecord::Migration
  def change
    add_column :transport_guides, :created_at, :date

  end
end
