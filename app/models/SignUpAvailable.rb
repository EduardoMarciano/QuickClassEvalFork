# Represents the availability of sign-up keys for user registration in the application.
#
# SignUpAvailable manages the creation and availability of sign-up keys using SecureRandom for generating keys.
#
require 'securerandom'
class SignUpAvailable < ApplicationRecord

  # @!group Scopes

  # Checks if a sign-up key is available for the given email.
  #
  # @param email [String] The email address to check.
  # @param key [String] The sign-up key to validate.
  #
  # @return [Boolean] True if the key is valid for the provided email, otherwise false.
  def self.check_availability(email, key)
    exists?(email: email, key: key)
  end
  
  # Creates a sign-up record with a key for the given email if it doesn't already exist.
  #
  # @param email [String] The email address for the new sign-up record.
  #
  # @return [SignUpAvailable, nil] The newly created record if successful, otherwise nil.
  def self.create_by_json(email)
    unless SignUpAvailable.exists?(email: email)
      create(email: email, key: SecureRandom.hex(5))
    end
  end

  # Updates all sign-up keys to a specific value (likely for administrative purposes).
  #
  # **Caution:** Use this method with care as it invalidates all existing sign-up keys.
  #
  def self.send_keys_availables_sign_up
    SignUpAvailable.update_all(key: "TOKEN_587")
  end
  
end
