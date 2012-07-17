class CreateTransportGuideDetails < ActiveRecord::Migration
  def change
    create_table :transport_guide_details do |t|
      t.integer :transport_guide_id, :null=>false
      t.integer :amount
      t.integer :product_type_id, :null=>false
      #en kilogramos
      t.decimal :weight

    end
    add_foreign_key :transport_guide_details, :transport_guides
    add_foreign_key :transport_guide_details, :product_types
  end
end
