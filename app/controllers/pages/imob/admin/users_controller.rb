# frozen_string_literal: true

module Pages
  module Imob
    module Admin
      class UsersController < Pages::Imob::Admin::BaseController
        before_action :set_user, only: [ :show, :edit, :update, :destroy ]

        def index
          @users = User.all
        end

        def show; end

        def new
          @user = User.new
        end

        def create
          @user = User.new(user_params)
          @user.password = generate_random_password

          if @user.save
            redirect_to pages_imob_admin_users_path(@user), notice: "Usuário criado com sucesso."
          else
            render :new, status: :unprocessable_entity, alert: "Erro ao criar o usuário."
          end
        end

        def edit; end

        def update
          if @user.update(user_params)
            redirect_to apages_imob_admin_users_path(@user), notice: "Usuário atualizado com sucesso."
          else
            render :edit, alert: "Erro ao atualizar o usuário."
          end
        end

        def destroy
          if @user.destroy
            redirect_to apages_imob_admin_users_path, notice: "Usuário excluído com sucesso."
          else
            redirect_to pages_imob_admin_user_path, alert: "Erro ao excluir o usuário."
          end
        end

        private

        def set_user
          @user = User.find(params[:id])
        end

        def user_params
          params.require(:users).permit(:email, :password, :role)
        end

        def generate_random_password
          length = rand(8..12)
          charset = [ ("a".."z"), ("A".."Z"), (0..9), %w[! @ # $ % ^ & *] ].map(&:to_a).flatten
          Array.new(length) { charset.sample }.join
        end
      end
    end
  end
end
