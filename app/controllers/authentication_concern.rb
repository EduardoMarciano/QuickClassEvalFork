# Module providing authentication-related methods for user authentication and authorization.
#
# This concern extends ActiveSupport::Concern and provides methods to:
# - Authenticate users based on cookie information.
# - Retrieve logged-in user information.
# - Verify user authentication from controllers.
# - Check if a user belongs to specified disciplines.
#
module AuthenticationConcern
  extend ActiveSupport::Concern

  # Checks if a user is authenticated based on cookie information.
  #
  # @return [Boolean] True if the user is authenticated, false otherwise.
  #
  def user_authenticated
    user_info = cookies.signed[:user_info]
    check_authentication_from_controller(user_info)
  end

  # Retrieves the logged-in user based on authenticated cookie information.
  #
  # @return [User, nil] The logged-in User object, or nil if not authenticated.
  #
  def logged_user
    return unless user_authenticated

    email = cookies.signed[:user_info].split('_').last
    User.find_by(email:)
  end

  # Checks user authentication status from controller using cookie value.
  #
  # @param cookie_value [String] The signed cookie value containing user info.
  # @return [Boolean] True if authentication is valid, false otherwise.
  #
  def check_authentication_from_controller(cookie_value)
    return false unless cookie_value.present?

    key, timestamp, email = cookie_value.split('_')
    return false unless key && timestamp && email

    user = User.find_by(email:)
    if user && key == user.session_key
      return true if Time.current.to_i - timestamp.to_i < 1.hour

      user.update(session_key: nil)
      cookies.delete(:user_info)
      false

    else
      cookies.delete(:user_info)
      false
    end
  end

  # Checks if the logged-in user belongs to specified disciplines.
  #
  # @param disciplines [Array<Discipline>] Array of Discipline objects to check against.
  # @return [Boolean] True if user belongs to any of the specified disciplines, false otherwise.
  #
  def user_belongs_to?(disciplines)
    return false unless user_authenticated

    disciplines = [disciplines] unless disciplines.respond_to?(:each)
    disciplines.each do |discipline|
      return true unless StudentDiscipline.where(student_email: logged_user.email,
                                                 discipline_code: discipline.code).first.nil?
    end
    false
  end
end
