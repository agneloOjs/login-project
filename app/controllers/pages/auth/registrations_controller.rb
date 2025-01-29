# frozen_string_literal: true

module Pages
  module Auth
    class RegistrationsController < Pages::Auth::BaseController
      skip_before_action :authenticate_request, only: [ :register ]

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
