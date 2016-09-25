class AddSeenByReceiverToMessageThreads < ActiveRecord::Migration[5.0]
  def change
    add_column :message_threads, :seen_by_receiver, :boolean, default: false
  end
end
