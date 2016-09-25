class Message < ApplicationRecord
  belongs_to :message_thread, required: false
  validates :sender_id, :body, :sent_at, presence: true
  belongs_to :sender, class_name: 'User'
  after_create :update_thread_last_reply_at

  private
  def update_thread_last_reply_at
    message_thread.update_attributes(last_reply_at: sent_at)
  end

end
