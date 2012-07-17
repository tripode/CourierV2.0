class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.string :name_payment, :null=>false, :limit=>20
      t.string :description, :limit=>50

    end
  end
end
