class CreateFunctionTypes < ActiveRecord::Migration
  def change
    create_table :function_types do |t|
      t.string :description, :limit=>30, :null=>false


    end
  end
end
