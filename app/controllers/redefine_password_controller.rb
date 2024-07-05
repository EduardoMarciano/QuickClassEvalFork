# Controller handling password reset actions.
#
# This controller includes AuthenticationConcern to provide authentication methods.
#
class RedefinePasswordController < ApplicationController
  include AuthenticationConcern

  # Renders the password reset form if the user is authenticated.
  # If the user is not authenticated, redirects to the root path with an alert message.
    def index
      if user_authenticated
        render :index
      else
        redirect_to root_path, alert: "Acesso não autorizado"
      end
    end
    
  # Handles the password reset process.
  #
  # Validates the presence of user email, password, and password confirmation.
  # Checks if the passwords match and updates the user's password if valid.
  # Redirects to the login path on success, or re-renders the form with error messages on failure.
    def redefine
        user_info = cookies.signed[:user_info]
        key, timestamp, email = user_info.split('_')

        password = params[:user][:password]
        password_confirmation = params[:user][:password_confirmation]
        
        if email.blank? || password.blank? || password_confirmation.blank?
          flash[:error] = "Todos os campos devem ser preenchidos."
          render :index
          return
        end
        
        user = User.find_by(email: email)
        
        if user.nil?
          flash[:error] = "Usuário não encontrado."
          render :index
          return
        end
        
        if password != password_confirmation
          flash[:error] = "As senhas devem coincidir."
          render :index
          return
        end
        
        salt = BCrypt::Engine.generate_salt
        hashed_password = BCrypt::Engine.hash_secret(password, salt)
        
        if user.update(password: hashed_password, salt: salt)
          redirect_to login_path, notice: "Senha redefinida com sucesso!"
        else
          flash[:error] = "Erro ao redefinir a senha. Tente novamente."
          render :index
        end
      end
    
      private
    
  # Permits only the password and password confirmation parameters for the user.
  #
  # @return [ActionController::Parameters] the permitted parameters
      def user_params
        params.require(:user).permit(:password, :password_confirmation)
      end
end
