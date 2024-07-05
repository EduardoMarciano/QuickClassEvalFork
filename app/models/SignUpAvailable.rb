# Represents the availability of sign-up keys for user registration in the application.
#
# SignUpAvailable manages the creation and availability of sign-up keys using SecureRandom for generating keys.
#
require 'securerandom'
class SignUpAvailable < ApplicationRecord
  def self.check_availability(email, key)
    exists?(email: email, key: key)
  end
  
  def self.create_by_json(email)
    unless SignUpAvailable.exists?(email: email)
      create(email: email, key: SecureRandom.hex(5))
    end
  end

  def self.send_keys_availables_sign_up
    SignUpAvailable.update_all(key: "TOKEN_587")
  end
  
end
