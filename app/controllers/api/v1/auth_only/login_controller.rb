# frozen_string_literal: true

module Api
  module V1
    module AuthOnly
      class LoginController < Api::V1::BaseController
        skip_before_action :authenticate_request, only: [ :login_only ]

        def new
          @user = User.new
          @user.build_profile
        end

        # Login
        def login_only
          user = User.find_by(email: params[:user][:email])

          # Verifica se o usuário existe
          if user.nil?
            render json: { error: "User not found." }, status: :unauthorized
            return
          end

          # Verifica se a senha está correta
          if user.authenticate(params[:user][:password])
            # Verifica se o usuário já tem o limite de tokens
            if user.allowlisted_tokens.where(revoked: false).where("expires_at > ?", Time.current).count >= 3
              render json: { error: "User already has the maximum allowed number of active tokens." }, status: :unauthorized
              return
            end

            # Gera o token JWT
            payload = { user_id: user.id }
            token = JwtService.encode(payload)

            # Cria o token na tabela de tokens permitidos
            AllowlistedToken.create!(token_jwt: token, expires_at: 24.hours.from_now, user: user)

            # Retorna o token para o cliente
            render json: { token: token }, status: :ok
          else
            render json: { error: "Invalid email or password." }, status: :unauthorized
          end
        end

        private

          # Gera um token JWT e armazena na allowlist
          def generate_token(user)
          raise "Expected User object, got #{user.class}" unless user.is_a?(User)

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
end
