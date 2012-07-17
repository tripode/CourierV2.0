require 'date'
Product.transaction do
  date= Time.now
  (1..2000).each do |t|
      Product.create(
        :bar_code=>"#{t}",
        :description=>"",
        :product_type_id => 1,
        :retire_note_id=> 5,
        :remitter=>"wildo monges",
        :product_state_id=>2,
        :receiver_id=>4,
        :created_at=>date,
        :receiver_address_id=>9
      )
   end
    

end