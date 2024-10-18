require 'bcrypt'

class User < ApplicationRecord
  has_many :rubberducks, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable
end
# comment
