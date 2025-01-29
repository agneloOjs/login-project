# frozen_string_literal: true

module Api
  module V1
    class AuthController < Api::V1::BaseController
      def new
        @user = User.new
        @user.build_profile
      end

      # Login
      def login
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          token = generate_token(user)
          render json: { token: token }, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      # Logout
      def logout
        if current_user
          invalidate_token(current_token)
          render json: { message: "Logged out successfully" }, status: :ok
        else
          render json: { error: "Not authenticated" }, status: :unauthorized
        end
      end


      # POST /api/v1/auth/register
      def register
        @user = User.new(register_params)
        @user.blocked = false
        @user.deleted = false
        @user.active = true

        if @user.save
          token = generate_token(@user.id)
            # render json: { token: token, user: @user.as_json(only: [ :id, :email ]) }, status: :created
            redirect_to pages_auth_session_path, notice: "Cadastro realizado com sucesso. Token gerado: #{token}"
        else
          Rails.logger.error "Erro ao criar usuário: #{@user.errors.full_messages}"
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        # Limpa todos os dados da sessão relacionados ao usuário
        session.delete(:user_id)    # Caso tenha um ID de usuário na sessão
        session.delete(:user_email) # Caso tenha o email ou outras informações na sessão

        flash[:notice] = "Você saiu com sucesso."
        redirect_to pages_auth_session_path # Redireciona para a página inicial
      end

      private

      def register_params
        params.require(:user).permit(:email, :password, profile_attributes: [ :first_name ])
      end

      # Gera um token JWT e armazena na allowlist
      def generate_token(user)
        token_jwt = SecureRandom.uuid
        expires_at = 24.hours.from_now
        token = JwtService.encode({ user_id: user.id, token_jwt: token_jwt }, expires_at)
        AllowlistedToken.create!(token_jwt: token_jwt, user: user, expires_at: expires_at)
        token
      end

      # Invalida um token (remove da allowlist)
      def invalidate_token(token)
        decoded = JwtService.decode(token)
        if decoded
          AllowlistedToken.where(token_jwt: decoded[:token_jwt]).destroy_all
        end
      end

      # Obtém o token do header da requisição
      def current_token
        request.headers["Authorization"]&.split(" ")&.last
      end
    end
  end
end
