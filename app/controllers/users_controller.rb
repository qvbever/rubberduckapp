class UsersController < ApplicationController
  before_action :set_user, only: :show

  def index
    @user = User.all
    @rubberducks = Rubberduck.all
  end

  def show
    @rubberducks = Rubberduck.all
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to users_path, alert: 'User not found'
  end
end
