class AddLastReplyAtToMessageThreads < ActiveRecord::Migration[5.0]
  def change
    add_column :message_threads, :last_reply_at, :datetime
  end
end
