# == ManagerController
#
# Controls routes for management. 
#
class ManagerController < ApplicationController
  include ManagerHelper
  include AuthenticationConcern

  ##
  # Controls route "/manager" and displays manager functionality if user is authenticated and has admin permissions.
  #
  def index
    if user_authenticated == true && admin_user? == true
      render 'index'
    else
      redirect_to root_path, alert: 'Acesso não autorizado'
    end
  end
end
