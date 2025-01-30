class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  helper_method :current_user, :user_signed_in?

  private

  # Verifica se o usuário está autenticado
  def authenticate_user!
    unless current_user
      redirect_to login_path, alert: "Você precisa fazer login para acessar esta página."
    end
  end

  # Retorna o usuário atual
  def current_user
    return @current_user if @current_user

    token = cookies[:auth_token]
    if token
      decoded = JwtService.decode(token)
      if decoded
        # Verifica se o token existe no banco de dados e não está revogado ou expirado
        allowlisted_token = AllowlistedToken.find_by(
          token_jwt: token,
          user_id: decoded[:user_id],
          revoked: false,
          expires_at: Time.current..Float::INFINITY
        )

        if allowlisted_token
          @current_user = User.find(decoded[:user_id])
        else
          # Remove o cookie se o token for inválido
          cookies.delete(:auth_token)
        end
      else
        # Remove o cookie se o token for inválido
        cookies.delete(:auth_token)
      end
    end
    @current_user
  end

  # Verifica se o usuário está logado
  def user_signed_in?
    current_user.present?
  end
end
