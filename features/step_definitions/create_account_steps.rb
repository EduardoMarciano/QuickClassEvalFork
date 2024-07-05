Given('I have received a password reset email with a code') do
    email = 'notified_email@example.com'
    SignUpAvailable.create_by_json(email)
    
    user_attributes = {
        email: '@example.com',
        password: '$2a$12$9sauXRcV/alggmsRweudU.oQv2grJQH/lq7M97PTlO7TB/2RVKNzu', # TOKEN_587
        salt: '$2a$12$9sauXRcV/alggmsRweudU.',
        created_at: Time.now,
        is_admin: false
    }

    SignUpAvailable.create_by_json(user_attributes[:email])
    SignUpAvailable.send_keys_availables_sign_up

    user = User.new
    user.email = user_attributes[:email]
    user.salt = user_attributes[:salt]
    user.password = user_attributes[:password]
    user.created_at = user_attributes[:created_at]
    user.is_admin = user_attributes[:is_admin]
    user.save
      
  end
  
  When('I enter the correct reset code') do
    fill_in 'key', with: 'TOKEN_587'
  end
  
  When('I enter an incorrect reset code') do
    fill_in 'key', with: 'incorrect_code'
  end
  
  When('I enter an email that has been notified') do
    fill_in 'email', with: 'notified_email@example.com'
  end
  
  When('I enter an email that has not been notified') do
    fill_in 'email', with: 'unnotified_email@example.com'
  end
  
  When('the email has already been registered') do
    fill_in 'email', with: '@example.com'
  end

  When('I enter matching password and confirmation password') do
    fill_in 'password', with: 'password123'
    fill_in 'password_confirmation', with: 'password123'
  end
  
  When('I enter a password') do
    fill_in 'password', with: 'password123'
  end
  
  When('I enter a different confirmation password') do
    fill_in 'password_confirmation', with: 'different_password123'
  end
  
  When('I click on Sign Up') do
    click_button 'Sign Up'
  end
  
  Then('I should be redirected to the login page') do
    expect(page).to have_current_path(login_path)
  end
  
  Then('I should see an error message {string}') do |message|
    expect(page).to have_content(message)
  end
  