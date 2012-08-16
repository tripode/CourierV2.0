

ActionMailer::Base.smtp_settings = {  
  :address              => "smtp.gmail.com",  
  :port                 => 587,  
  :domain               => "dsrepresentaciones.com",  
  :user_name            => "ds.representaciones.py@gmail.com",  
  :password             => "tripodevs2012",  
  :authentication       => "login",  
  :enable_starttls_auto => true  
}