# app/controllers/api/v1/auth_controller.rb
module Api
  module V1
    class AuthController < Api::V1::BaseController
      skip_before_action :authenticate_user!, only: [ :login, :register ]

      # POST /api/v1/auth/login
      def login
        user = User.find_by(email: params[:email])

        if user && user.authenticate(params[:password])
          if user.active? && !user.blocked? && !user.deleted?
            token = generate_token(user.id)
            render json: { token: token, user: user.as_json(only: [ :id, :email ]) }, status: :ok
          else
            render json: { error: "Sua conta está inativa ou bloqueada" }, status: :unauthorized
          end
        else
          render json: { error: "Email ou senha inválidos" }, status: :unauthorized
        end
      end

      # POST /api/v1/auth/register
      def register
        @user = User.new(user_params)
        @user.blocked = false
        @user.deleted = false
        @user.active = true

        if @user.save
          token = generate_token(@user.id)
            # render json: { token: token, user: @user.as_json(only: [ :id, :email ]) }, status: :created
            redirect_to root_path, notice: "Cadastro realizado com sucesso. Token gerado: #{token}"
        else
          Rails.logger.error "Erro ao criar usuário: #{@user.errors.full_messages}"
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, profile_attributes: [ :first_name ])
      end

      def generate_token(user_id)
        JWT.encode({ user_id: user_id, exp: 24.hours.from_now.to_i }, Rails.application.credentials.secret_key_base)
      end
    end
  end
end
