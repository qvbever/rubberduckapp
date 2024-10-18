class Booking < ApplicationRecord
  belongs_to :rubberduck
  belongs_to :user

  validate :start_date_cannot_be_in_the_past
  validate :end_date_after_start_date
  private

  def start_date_cannot_be_in_the_past
    if start_date.present? && start_date < Date.today
      errors.add(:start_date, "can't be in the past")
    end
  end

  def end_date_after_start_date
    if end_date.present? && start_date.present? && end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
