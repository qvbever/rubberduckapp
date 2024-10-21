class Rubberduck < ApplicationRecord
  has_many :bookings
  belongs_to :user
  geocoded_by :city
  after_validation :geocode, if:
  :will_save_change_to_city?
end
