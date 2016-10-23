class AddRecieverIdToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :receiver_id, :integer
  end
end
