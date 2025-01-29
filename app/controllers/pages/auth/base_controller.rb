module Pages
  module Auth
    class BaseController < ApplicationController
      layout "auth/layout"

      def user_signed_in?
        !!current_user # Verifica se há um usuário autenticado
      end
    end
  end
end
