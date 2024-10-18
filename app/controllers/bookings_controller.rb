class BookingsController < ApplicationController
  def new
    @rubberduck = Rubberduck.find(params[:rubberduck_id])
    @booking = Booking.new
  end

  def create
    @rubberduck = Rubberduck.find(params[:rubberduck_id])
    @booking = @rubberduck.bookings.build(booking_params)
    @booking.user = current_user

    puts params.inspect  # Add this line to inspect the incoming parameters

    if @booking.save
      redirect_to @rubberduck, notice: "Booking successful!"
    else
      render "rubberducks/show"
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end
end
