class Message < ApplicationRecord
  belongs_to :message_thread, required: false
  validates :sender_id, :sender_id, :body, :sent_at, presence: true
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  after_create :update_thread_last_reply_at, :increment_reciever_notif_counter,
    :send_new_message_notification

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

  def increment_reciever_notif_counter
    receiver.increment!(:message_notif_count, 1)
  end

  def send_new_message_notification
    UserMailer.new_message_notification(self, sender, receiver).deliver_now
  end

end
