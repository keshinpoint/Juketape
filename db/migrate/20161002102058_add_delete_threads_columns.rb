class AddDeleteThreadsColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :message_threads, :deleted_by_sender, :boolean, default: false
    add_column :message_threads, :deleted_by_receiver, :boolean, default: false
    add_column :message_threads, :deleted_id_by_sender, :integer, default: 0
    add_column :message_threads, :deleted_id_by_receiver, :integer, default: 0
  end
end
