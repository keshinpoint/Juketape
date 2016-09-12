class TimelineEvent < ApplicationRecord
  validates :title, :description, :start_date, presence: true
  # validates :end_date_validation

  def end_time
    at_present? ? 'present' : end_date
  end

  private

  def end_date_validation
    if end_date.blank? && !at_present?
      errors.add(:base, 'Please select End date')
    end
  end
end
