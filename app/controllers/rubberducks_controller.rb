class RubberducksController < ApplicationController
  # skip_before_action :authenticate_user!, only: :index
  before_action :set_user, only: [:new, :create]

  def index
    @rubberducks = Rubberduck.all
    # @rubberducks = @user.rubberducks
    if params[:user_id]
      @user = User.find(params[:user_id])
      @rubberducks = @user.rubberducks
    else
      @rubberducks = Rubberduck.all
    end
  end

  def new
    # @rubberduck = Rubberduck.new
    @rubberduck = @user.rubberducks.build
  end

  def create
    @rubberduck = @user.rubberducks.build(rubberduck_params)
    # @rubberduck = Rubberduck.new(rubberduck_params)
    # @rubberduck.user = @user
    if @rubberduck.save
      redirect_to user_rubberduck_path(@user, @rubberduck)
    else
      render "new", status: :unprocessable_entity
    end
  end

  def show
    @rubberduck = Rubberduck.find(params[:id])
    # @rubberduck = @user.rubberducks.find(params[:id])
    @booking = Booking.new
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def rubberduck_params
    params.require(:rubberduck).permit(:name, :city, :outfit, :price)
  end
end
