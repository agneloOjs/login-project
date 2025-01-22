# frozen_string_literal: true

module Pages
  module Imob
    module Admin
      class UsersController < Pages::Imob::Admin::BaseController
        def index
          @users = User.all
        end
      end
    end
  end
end
