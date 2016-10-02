class Message < ApplicationRecord
  belongs_to :message_thread, required: false
  validates :sender_id, :body, :sent_at, presence: true
  belongs_to :sender, class_name: 'User'
  after_create :update_thread_last_reply_at

  def seen!
    update_attributes!(seen: true)
  end

  private
  def update_thread_last_reply_at
    message_thread.update_attributes({
      last_reply_at: sent_at,
      deleted_by_sender: false,
      deleted_by_receiver: false
    })
  end

end
