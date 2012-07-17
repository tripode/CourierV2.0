class SetAsIndexUniqueToBarcodeProducts < ActiveRecord::Migration
  def up
    add_index :products, :bar_code, :unique => true
  end

  def down
  end
end
