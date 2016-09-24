class TimelineEvent < ApplicationRecord
  validates :title, :description, :start_date, presence: true
  validate :end_date_validation

  def end_time
    at_present? ? 'present' : end_date
  end

  private

  def end_date_validation
    return true if at_present?
    if end_date.blank?
      errors.add(:base, 'Please select End date')
    elsif end_date < start_date
      errors.add(:base, 'The end date should be greater than or equal to the start date')
    end
  end
end
