# Controller handling the index action for the application.
#
# This controller includes AuthenticationConcern to provide authentication methods.
#
class IndexController < ApplicationController
  include AuthenticationConcern

  # Handles the index action.
  #
  # If the user is authenticated, redirects to the evaluations path.
  # If the user is not authenticated, redirects to the login path with an alert message.
  #
  def index
    if self.user_authenticated
      redirect_to evaluations_path
    else
      redirect_to login_path, alert: "Acesso não autorizado"
    end
  end  
end
