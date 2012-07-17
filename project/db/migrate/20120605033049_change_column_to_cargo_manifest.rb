class ChangeColumnToCargoManifest < ActiveRecord::Migration
  def change
    change_column :cargo_manifests, :manifest_num, :integer, :null=>false, :unique => true
    change_column :cargo_manifests, :total_guides, :integer, :null=>false
    change_column :cargo_manifests, :total_products, :integer, :null=>false
    change_column :cargo_manifests, :created_at, :date, :null=>false

  end
end
