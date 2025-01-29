# frozen_string_literal: true

module Api
  module V1
    module AuthOnly
      class RegisterController < Api::V1::BaseController
        skip_before_action :authenticate_request, only: [ :register_only ]

        def new
          @user = User.new
          @user.build_profile
        end

        # register
        def register_only
          @user = User.new(register_only_params)
          @user.blocked = false
          @user.deleted = false
          @user.active = true

          if @user.save
            redirect_to pages_auth_session_path, notice: "Cadastro realizado com sucesso."
          else
            redirect_to pages_auth_registration_path, alert: "Erro ao criar registro."
          end
        end

        private

        def register_only_params
          params.require(:user).permit(:email, :password, profile_attributes: [ :first_name ])
        end
      end
    end
  end
end
