class RubberducksController < ApplicationController
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
    @rubberduck = if params[:user_id].present?
                    User.find(params[:user_id]).rubberducks.find(params[:id])
                  else
                    Rubberduck.find(params[:id])
                  end
    @user = @rubberduck.user
    @booking = Booking.new

    # Generate 3-5 fake reviews using Faker
    @reviews = Array.new(rand(3..5)) do
      {
        author: Faker::Name.name,
        content: Faker::Lorem.sentence(word_count: 30),
        rating: rand(3..5) # Random rating between 3 and 5
      }
    end

    # Initialize @pricing_info with default values
    @pricing_info = {
      price_per_bath: @rubberduck.price,
      total_bath_cost: 0,    # Default values until dates are selected
      cleaning_fee: 0,       # Default cleaning fee
      service_fee: 0,        # Default service fee
      total_cost: 0          # Default total cost
    }
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

  include BookingsHelper

  # API for calculating price
  def calculate_price
    rubberduck = Rubberduck.find(params[:id])

    begin
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])

      if start_date > end_date
        render json: { error: 'Start date cannot be after end date' }, status: :unprocessable_entity and return
      end

      num_days = (end_date - start_date).to_i + 1
      pricing_info = calculate_total_price(rubberduck, num_days)

      render json: pricing_info.merge(num_days: num_days)

    rescue ArgumentError
      render json: { error: 'Invalid dates provided' }, status: :unprocessable_entity
    end
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
