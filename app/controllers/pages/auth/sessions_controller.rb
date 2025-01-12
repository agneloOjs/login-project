module Pages
  module Auth
    class SessionsController < Pages::Auth::BaseController
      def new
      end

      def create
        user = User.find_by(email: params[:session][:email])

        if user && user.authenticate(params[:session][:password])
          if user.active? && !user.blocked? && !user.deleted?
            session[:user_id] = user.id
            redirect_to root_path, notice: "Login realizado com sucesso!"
          else
            flash.now[:error] = "Sua conta está inativa ou bloqueada"
            render :index, status: :unprocessable_entity
          end
        else
          flash.now[:error] = "Email ou senha inválidos"
          render :index, status: :unprocessable_entity
        end
      end

      def destroy
        session[:user_id] = nil
        redirect_to new_pages_auth_session_path, notice: "Logout realizado com sucesso!"
      end
    end
  end
end
