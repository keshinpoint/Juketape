class InstagramNetwork < ApplicationRecord
  belongs_to :user
  validates :access_token, presence: true

end