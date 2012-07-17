class CreateCargoManifestDetails < ActiveRecord::Migration
  def change
    create_table :cargo_manifest_details do |t|
      t.integer :cargo_manifest_id
      t.integer :transport_guide_id

    end
    add_foreign_key :cargo_manifest_details, :cargo_manifests
    add_foreign_key :cargo_manifest_details, :transport_guides
  end
end
