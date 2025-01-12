# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user!
    unless user_signed_in?
      flash[:error] = "Você precisa estar logado para acessar esta página"
      redirect_to new_pages_auth_session_path
    end
  end
end
