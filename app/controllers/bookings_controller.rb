class BookingsController < ApplicationController
  def new
    @rubberduck = Rubberduck.find(params[:rubberduck_id])
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

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end
end
