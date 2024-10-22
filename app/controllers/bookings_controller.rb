# app/controllers/bookings_controller.rb
class BookingsController < ApplicationController
  include BookingsHelper

  def show
    @rubberduck = Rubberduck.find(params[:id])
    num_days = calculate_number_of_days(params[:start_date], params[:end_date])

    @pricing_info = calculate_total_price(@rubberduck, num_days)
    @booking = Booking.new
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
