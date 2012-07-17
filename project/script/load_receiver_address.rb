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