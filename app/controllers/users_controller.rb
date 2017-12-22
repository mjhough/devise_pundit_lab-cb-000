class UsersController < ApplicationController
  before_action :find_user!, only: %i(show)
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    @users = User.all
  end

  def show
    authorize(@user)
  end

  private

  def find_user!
    @user = User.find(params[:id])
  end

  def user_not_authorized
    redirect_to user_path(current_user), alert: 'Access denied.'
  end
end