# Represents a user of the application.
#
# Users are individuals who have accounts and interact with various features within the application.
#
class User < ApplicationRecord
  # @!group Relationships

  # A user can have many answers.
  #
  # @return [Array<Answer>] A collection of answers associated with the user.
  has_many :answers

  # @!group Scopes

  # Finds a user by their email address.
  #
  # @param email [String] The email address of the user to find.
  #
  # @return [User, nil] The user record if found, otherwise nil.
  def self.find(email)
    find_by(email:)
  end

  # Authenticates a user based on their user ID and password.
  #
  # @param user_id [Integer] The ID of the user to authenticate.
  # @param password [String] The password to authenticate with.
  #
  # @return [Boolean] True if the credentials are valid, otherwise false.
  def self.authenticate(user_id, password)
    user = find_by(id: user_id)
    return false unless user && user.salt.present?

    hashed_password = BCrypt::Engine.hash_secret(password, user.salt)

    hashed_password == user.password
  end

  # Generates a new session key for the user and saves it to the database.
  #
  # @return [String] The newly generated session key.
  def generate_session_key
    self.session_key = SecureRandom.hex(30)
    save
    session_key
  end

  # Creates a new user record.
  #
  # This method validates the presence of email, password, and password confirmation.
  # It also ensures passwords match before creating the user.
  #
  # @param email [String] The email address of the user.
  # @param password [String] The password for the user.
  # @param password_confirmation [String] The confirmation of the user's password.
  #
  # @return [User, nil] The newly created user record if successful, otherwise nil.
  def self.criarUser(email, password, password_confirmation)
    return nil if email.blank? || password.blank? || password_confirmation.blank? || password != password_confirmation

    salt = BCrypt::Engine.generate_salt
    hashed_password = BCrypt::Engine.hash_secret(password, salt)

    create(email:, salt:, password: hashed_password, created_at: Time.current)
  end
end
