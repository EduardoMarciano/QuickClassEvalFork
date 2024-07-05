# Controller handling user registration actions.
#
# This controller provides methods for rendering the registration form and creating new user accounts.
#
class RegistrationsController < ApplicationController

  # Renders the registration form.
  def index
    render 'create'
  end

  # Handles the user registration process.
  #
  # Validates the presence of email, password, password confirmation, and registration key.
  # Checks if the email and key are available in the SignUpAvailable table.
  # If the email is already registered, renders the form with an error message.
  # If the email and key are valid, creates a new user and redirects to the login path on success.
  # If the passwords do not match, renders the form with an error message.
  # If the email or key are invalid, renders the form with an error message.
  def create
    email = user_params[:email]
    password = user_params[:password]
    password_confirmation = user_params[:password_confirmation]
    key = user_params[:key]
    
    if email.blank? || password.blank? || password_confirmation.blank? || key.blank?
      flash[:error] = "Todos os campos devem ser preenchidos."
      render :create
      return
    end    

    # Verifies if the email and key are available in the SignUpAvailable table
    if SignUpAvailable.check_availability(email, key)
      if User.find_by(email: email)
        flash[:error] = "Email já cadastrado, entre em contato com o administrador."
        render :create
        return
      else
        @user = User.criarUser(email, password, password_confirmation)

        if @user.present? && @user.persisted?
          redirect_to login_path, notice: "Usuário criado com sucesso!"
        else
          flash[:error] = "As senhas devem coincidir."
          render :create
          return
        end
      end
    else
      flash[:error] = "Email ou chave de cadastro inválidos, entre em contato com seu coordenador."
      render :create
    end
  end

  private

  # Permits only the email, password, password confirmation, and registration key parameters for the user.
  #
  # @return [ActionController::Parameters] the permitted parameters
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :key)
  end
end
