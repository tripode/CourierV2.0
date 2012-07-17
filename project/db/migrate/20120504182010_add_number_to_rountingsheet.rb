class AddNumberToRountingsheet < ActiveRecord::Migration
  def change
    add_column :routing_sheets, :number, :integer
  end
end
