class MessageThread < ApplicationRecord
  has_many :messages, -> { order(sent_at: :asc) }, dependent: :destroy
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  before_validation :generate_slug, on: :create
  validates :slug, :sender_id, :receiver_id, :subject, :sent_at, presence: true
  accepts_nested_attributes_for :messages

  def last_message
    messages.last
  end

  def seen!
    update_attributes!(seen_by_receiver: true)
  end

  private
  def generate_slug
    self.slug = SecureRandom.urlsafe_base64(9)
    generate_slug if MessageThread.exists?(slug: slug)
  end
end
