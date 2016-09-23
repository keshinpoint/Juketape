class Invitation < ApplicationRecord
  belongs_to :initiator, class_name: 'User', foreign_key: :initiator_id
  belongs_to :invitee,   class_name: 'User', foreign_key: :invitee_id

  enum status: [:pending, :accepted, :rejected]
  validates :initiator_id, uniqueness: { scope: :invitee_id }
end
