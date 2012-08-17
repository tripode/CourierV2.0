class UpdateRucTo14 < ActiveRecord::Migration
  def up
  change_column :customers, :ruc, :varchar, :limit => 14
  end

  def down
  end
end
