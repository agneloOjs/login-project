# app/controllers/api/v1/auth_controller.rb
module Api
  module V1
    class AuthController < Api::V1::BaseController
      skip_before_action :authenticate_user!, only: [ :login, :register ]

      def new
        @user = User.new
        @user.build_profile
      end

      # POST /api/v1/auth/login
      def login
        user = User.find_by(email: params[:user][:email])

        if user && user.authenticate(params[:user][:password])
          if user.active? && !user.blocked? && !user.deleted?
            token = generate_token(user.id)
            flash[:notice] = "Login realizado com sucesso."
            redirect_to root_path
          else
            flash[:alert] = "Sua conta está inativa ou bloqueada."
            redirect_to pages_auth_session_path
          end
        else
          flash[:alert] = "Email ou senha inválidos."
          redirect_to pages_auth_session_path
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

      def generate_token(user_id)
        JWT.encode({ user_id: user_id, exp: 24.hours.from_now.to_i },
        Rails.application.credentials.secret_key_base)
      end
    end
  end
end
