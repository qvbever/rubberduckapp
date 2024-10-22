module BookingsHelper
  # Calculate total price including fees for the booking
  def calculate_total_price(rubberduck, num_days)
    price_per_bath = rubberduck.price
    total_bath_cost = price_per_bath * num_days

    # You can customize these fees instead of random values
    cleaning_fee = 5.00 # Example fixed cleaning fee
    service_fee = (0.1 * total_bath_cost).round(2) # 10% service fee

    total_cost = (total_bath_cost + cleaning_fee + service_fee).round(2)

    {
      price_per_bath: price_per_bath,
      total_bath_cost: total_bath_cost,
      cleaning_fee: cleaning_fee,
      service_fee: service_fee,
      total_cost: total_cost
    }
  end
end
