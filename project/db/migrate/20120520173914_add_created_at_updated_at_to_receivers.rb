class AddCreatedAtUpdatedAtToReceivers < ActiveRecord::Migration
  def change
    add_column :receivers, :created_at, :date
    add_column :receivers, :updated_at, :date

  end
end
