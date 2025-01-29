# frozen_string_literal: true

module Pages
  module Imob
    module Admin
      class BaseController < ApplicationController
        # before_action :authenticate_user!
        skip_before_action :authenticate_request, only: [ :index ]

        layout "imob/admin/layout"
      end
    end
  end
end
