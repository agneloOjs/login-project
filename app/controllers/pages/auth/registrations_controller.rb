module Pages
  module Auth
    class RegistrationsController < Pages::Auth::BaseController
      def new
        @user = User.new
        @user.build_profile
      end

      # Cria um novo usuário
      def create
        @user = User.new(user_params)
        @user.blocked = false
        @user.deleted = false
        @user.active = true

        if @user.save
          redirect_to pages_auth_sessions_path, notice: "Cadastro realizado com sucesso."
        else
          flash.now[:error] = "Erro ao criar usuário"
          render :new, status: :unprocessable_entity
        end
      end

      private

      # Permite apenas os parâmetros necessários para criar um novo usuário
      def user_params
        params.require(:user).permit(:email, :password, profile_attributes: [ :first_name ])
      end
    end
  end
end
