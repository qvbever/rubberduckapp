# app/controllers/bookings_controller.rb
class BookingsController < ApplicationController
  include BookingsHelper

  def show
    @rubberduck = Rubberduck.find(params[:id])
    num_days = calculate_number_of_days(params[:start_date], params[:end_date])

    @pricing_info = calculate_total_price(@rubberduck, num_days)
    @booking = Booking.new
    @booking.user = current_user
  end

  def create
    @rubberduck = Rubberduck.find(params[:rubberduck_id])
    @booking = @rubberduck.bookings.build(booking_params)
    @booking.user = current_user
    @user = current_user

    if @booking.save
      redirect_to profile_path, notice: "Booking successful!"
    else
      render "rubberducks/show"
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    redirect_to profile_path, notice: "Booking deleted!"
  end

  def edit
    @booking = Booking.find(params[:id])
    @rubberduck = @booking.rubberduck
  end

  def update
    @booking = Booking.find(params[:id])

    if @booking.update(booking_params)
      redirect_to profile_path, notice: "Booking updated successfully!"
    else
      render :edit  # Render the edit form again if there are validation errors
    end
  end

  private

  def calculate_number_of_days(start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)
    (end_date - start_date).to_i + 1 # Calculate inclusive number of days
  end
end

def calculate_price
  rubberduck = Rubberduck.find(params[:id])
  num_days = calculate_number_of_days(params[:start_date], params[:end_date])

  pricing_info = calculate_total_price(rubberduck, num_days)

  render json: pricing_info.merge(num_days: num_days)
end
