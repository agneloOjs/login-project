class ApplicationController < ActionController::Base
  before_action :authenticate_request
  helper_method :current_user, :user_signed_in?

  attr_reader :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    session[:user_id].present?
  end

  private

  # Verifica se o token é válido e autentica o usuário
  def authenticate_request
    token = request.headers["Authorization"]&.split(" ")&.last
    if token
      decoded = JwtService.decode(token)
      if decoded && AllowlistedToken.valid?(decoded[:jti])  # Verifica a validade do token usando o jti
        @current_user = User.find(decoded[:user_id])  # Identifica o usuário pelo ID do token
      else
        render json: { error: "Not authenticated" }, status: :unauthorized
      end
    else
      render json: { error: "Token missing" }, status: :unauthorized
    end
  end
end
