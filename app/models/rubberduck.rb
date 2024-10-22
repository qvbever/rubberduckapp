class Rubberduck < ApplicationRecord
  has_many :bookings
  belongs_to :user

  include PgSearch::Model
  pg_search_scope :search_by_name_city_outfit,
  against: [:name, :city, :outfit],
  using: {
    tsearch: { prefix: true } # <-- now `superman batm` will return something!
  }
end
