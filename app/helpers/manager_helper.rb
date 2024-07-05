# Module to provide helper methods related to user management and current semester.
module ManagerHelper
  # Checks if the current user is an admin based on stored user info in cookies.
  #
  # @return [Boolean] True if the current user is an admin, false otherwise.
  #
  def admin_user?
    user_info = cookies.signed[:user_info]
    return false unless user_info.present?

    _, _, email = user_info.split('_')
    return false unless email.present?

    user = User.find_by(email:)
    user&.is_admin || false
  end

  # Retrieves the current semester.
  #
  # @return [Semester] The current semester object.
  #
  def current_semester
    Semester.current_semester
  end
end
