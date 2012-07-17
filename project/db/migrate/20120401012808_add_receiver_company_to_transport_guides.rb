class AddReceiverCompanyToTransportGuides < ActiveRecord::Migration
  def change
    add_column :transport_guides, :receiver_company_id, :integer, :null=>false

    #el fk receiver_company_id se une con customers
    constraint_name = "fk_transport_guides_receiver_company_id"

    execute "alter table transport_guides
              add constraint #{constraint_name}
              foreign key (receiver_company_id)
              references customers(id)"

  end
end
