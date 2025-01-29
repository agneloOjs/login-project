# frozen_string_literal: true

module Pages
  module Website
    class HomeController < ApplicationController
      skip_before_action :authenticate_request, only: [ :index ]


      layout "website/layout"
      def index
        @users = User.includes(:profile)
      end
    end
  end
end
