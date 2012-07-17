Receiver.transaction do
  Receiver.create(:receiver_name => "Villalba Teresa",:document=> "3539120")
  Receiver.create(:receiver_name => "Ocampo Rober",  :document=> "4500632")
  Receiver.create(:receiver_name => "Monges Karla",  :document=> "3539456")
  Receiver.create(:receiver_name => "Espinoza Jose", :document=> "3120000")
  Receiver.create(:receiver_name => "Garcete Sofia", :document=> "4258966")
end
ReceiverAddress.transaction do
  ReceiverAddress.create(:label => "Casa", :address => "direccion casa", :city_id => 1, :receiver_id => 1)
  ReceiverAddress.create(:label => "Oficina", :address => "direccion oficina", :city_id => 1, :receiver_id => 1)
  ReceiverAddress.create(:label => "Casa", :address => "direccion casa", :city_id => 2, :receiver_id => 2)
  ReceiverAddress.create(:label => "Oficina", :address => "direccion oficina", :city_id => 1, :receiver_id => 2)
  ReceiverAddress.create(:label => "Facultad", :address=> "direccion facultad", :city_id => 3, :receiver_id => 3)
  ReceiverAddress.create(:label => "Casa", :address => "direccion casa", :city_id => 1, :receiver_id => 3)
  ReceiverAddress.create(:label => "Oficina", :address => "direccion oficina", :city_id => 1, :receiver_id => 3)
  ReceiverAddress.create(:label => "Casa 1", :address => "direccion casa 1", :city_id => 1, :receiver_id => 4)
  ReceiverAddress.create(:label  => "Casa 2", :address => "direccion casa 2", :city_id => 1, :receiver_id => 4)
  ReceiverAddress.create(:label => "Casa 3", :address => "direccion casa 3", :city_id => 1, :receiver_id => 4)
end