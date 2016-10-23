class AddNotificationCountToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :message_notif_count, :integer, default: 0
    add_column :users, :connection_notif_count, :integer, default: 0
  end
end
