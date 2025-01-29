# frozen_string_literal: true

module Api
  module V1
    module AuthOnly
      class PasswordController < Api::V1::BaseController
        skip_before_action :authenticate_request, only: [ :logout_only ]

        def password_reset
          if current_user
            # Destruir a sessão do usuário
            session[:user_id] = nil  # Limpar a sessão (isso "desloga" o usuário)

            # Redirecionar para a página de login após o logout
            redirect_to pages_auth_conecte_se_path, notice: "Logged out successfully"
          else
            redirect_to root_path, alert: "Not authenticated"
          end
        end
      end
    end
  end
end
