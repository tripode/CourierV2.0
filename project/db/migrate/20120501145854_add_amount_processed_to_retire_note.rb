class AddAmountProcessedToRetireNote < ActiveRecord::Migration
  def change
    add_column :retire_notes, :amount_processed, :integer, :default => 0
  end
end
