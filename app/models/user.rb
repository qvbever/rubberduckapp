require 'bcrypt'

class User < ApplicationRecord
  has_many :rubberducks, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable
  has_many :bookings

  def average_rubberduck_rating
    return 0 if rubberducks.empty?
    rubberducks.average(:rating).to_f.round(2)
  end
end
# comment
