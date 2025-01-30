# frozen_string_literal: true

module Pages
  module Auth
    class BaseController < ApplicationController
      skip_before_action :authenticate_user!

      layout "auth/layout"

      def user_signed_in?
        !!current_user # Verifica se há um usuário autenticado
      end
    end
  end
end
