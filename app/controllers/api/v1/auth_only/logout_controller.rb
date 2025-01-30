# frozen_string_literal: true

module Api
  module V1
    module AuthOnly
      class LogoutController < Api::V1::BaseController
        skip_before_action :authenticate_user!

        def logout_only
          if current_user
            # Destruir a sessão do usuário
            session[:user_id] = nil  # Limpar a sessão (isso "desloga" o usuário)

            # Redirecionar para a página de login após o logout
            redirect_to pages_auth_conecte_se_path, notice: "Logged out successfully"
          else
            redirect_to root_path, alert: "Not authenticated"
          end

          token = cookies[:auth_token]
          if token
            # Remove o token do banco de dados
            AllowlistedToken.where(token_jwt: token).destroy_all

            # Remove o cookie
            cookies.delete(:auth_token)
          end
          redirect_to root_path, notice: "Logout realizado com sucesso."
        end
      end
    end
  end
end
class LogoutController < ApplicationController
  def destroy
  end
end
