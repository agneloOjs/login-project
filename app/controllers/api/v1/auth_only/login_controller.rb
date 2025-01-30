# frozen_string_literal: true

module Api
  module V1
    module AuthOnly
      class LoginController < Api::V1::BaseController
        def login_only
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          # Gera o token JWT
          token = JwtService.encode({ user_id: user.id })

          # Armazena o token no banco de dados
          AllowlistedToken.create!(
            token_jwt: token,
            user: user,
            expires_at: 24.hours.from_now,  # Define a expiração do token
            revoked: false
          )

          # Armazena o token em um cookie seguro
          cookies[:auth_token] = {
            value: token,
            expires: 24.hours.from_now,
            httponly: true,  # Impede acesso via JavaScript
            secure: Rails.env.production?  # Usa HTTPS em produção
          }

          redirect_to root_path, notice: "Login realizado com sucesso."
        else
          flash[:alert] = "E-mail ou senha inválidos."
          redirect_to login_path
        end
      end
    end
  end
end
