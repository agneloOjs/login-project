module Pages
  module Auth
    class PasswordsController < Pages::Auth::BaseController
      def reset
        if user_signed_in?
          flash[:notice] = "Você já está logado."
          redirect_to root_path
        end
      end
    end
  end
end
