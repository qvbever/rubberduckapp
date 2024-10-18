class RubberducksController < ApplicationController
  # skip_before_action :authenticate_user!, only: :index
  before_action :set_user
  before_action :set_rubberduck, only: [:edit, :update, :destroy]

  def index
    @rubberducks = Rubberduck.all
  end

  def new
    @user = User.find(params[:user_id])
    @rubberduck = @user.rubberducks.build
  end

  def create
    @rubberduck = @user.rubberducks.build(rubberduck_params)
    if @rubberduck.save
      redirect_to user_path(@user), notice: 'Rubberduck was successfully created.'
    else
      render "new", status: :unprocessable_entity
    end
  end

  def show
    @rubberduck = Rubberduck.find(params[:id])
    # @rubberduck = @user.rubberducks.find(params[:id])
    @booking = Booking.new
    if params[:user_id].present?
      @user = User.find(params[:user_id])
      @rubberduck = @user.rubberducks.find(params[:id])
    else
      @rubberduck = Rubberduck.find(params[:id])
      @user = @rubberduck.user
    end
  end

  def edit
    @user = @rubberduck.user
  end

  def update
    @rubberduck.update(rubberduck_params)
    redirect_to rubberduck_path(@rubberduck)
  end

  def destroy
    @rubberduck.destroy
    redirect_to user_path(@user), status: :see_other
  end

  private

  def set_user
    @user = current_user
  end

  def set_rubberduck
    @rubberduck = Rubberduck.find(params[:id])
  end

  def rubberduck_params
    params.require(:rubberduck).permit(:name, :city, :outfit, :price, :description)
  end
end
