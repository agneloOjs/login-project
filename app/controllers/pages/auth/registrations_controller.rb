module Pages
  module Auth
    class RegistrationsController < Pages::Auth::BaseController
      def new
        @user = User.new
        @user.build_profile

        if user_signed_in?
          flash[:notice] = "Você já está logado."
          redirect_to root_path
        end
      end
    end
  end
end
