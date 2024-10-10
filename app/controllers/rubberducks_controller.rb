class RubberducksController < ApplicationController

  def index
    @rubberducks = Rubberduck.all
  end

  def new
    @rubberduck = Rubberduck.new
  end

  def create
    @user = User.find(params[:user_id])
    @rubberduck = Rubberduck.new(rubberduck_params)
    @rubberduck.user = @user
    if @rubberduck.save
      redirect_to rubberducks_path
    else
      render "rubberducks/index", status: :unprocessable_entity
    end
  end

  private

  def rubberduck_params
    params.require(:rubberduck).permit(:name, :city, :outfit, :price)
  end
end
