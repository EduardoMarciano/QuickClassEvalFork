module AuthenticationConcern
  extend ActiveSupport::Concern

  def authenticate_user
    user_info = cookies.signed[:user_info]
    unless check_authentication_from_controller(user_info)
      flash[:error] = "Usuário não autenticado"
      redirect_to login_path
    end
  end

  def check_authentication_from_controller(cookie_value)
    if cookie_value.present?
      key, timestamp, email = cookie_value.split('_')
      puts "Informações do usuário: #{cookie_value.inspect}"
      if Time.current.to_i - timestamp.to_i < 1.hour
        user = User.find_by(email: email)

        if user && key == user.session_key
          puts "Usuário autenticado: #{email}"
          return true
        end
      end
    end
    puts "Falha na autenticação para: #{email}"
    return false
  end
end