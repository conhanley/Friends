ActionMailer::Base.smtp_settings = {  
    :address              => "smtp.mail.yahoo.com",  
    :port                 => 587,  
    :user_name            => "<your email address here>",  
    :password             => "your password here",  
    :authentication       => "plain",  
    :enable_starttls_auto => true  
  }