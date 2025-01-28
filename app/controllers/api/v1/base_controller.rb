# app/controllers/api/v1/base_controller.rb
module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_user!

      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActionController::ParameterMissing, with: :bad_request

      private

      # Método para autenticar o usuário com JWT
      def authenticate_user!
        header = request.headers["Authorization"]
        token = header.split(" ").last if header

        begin
          decoded = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: "HS256")
          @current_user = User.find(decoded[0]["user_id"])
        rescue JWT::DecodeError, ActiveRecord::RecordNotFound
          render json: { error: "Unauthorized" }, status: :unauthorized
        end
      end

      # Métodos para tratamento de erros
      def not_found
        render json: { error: "Record not found" }, status: :not_found
      end

      def bad_request
        render json: { error: "Bad request" }, status: :bad_request
      end
    end
  end
end
