class PagesController < ApplicationController
  def home
  end

  def profile
    @bookings = current_user.bookings
  end
end
