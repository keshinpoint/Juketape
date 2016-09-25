class CreateMessageThreads < ActiveRecord::Migration[5.0]
  def change
    create_table :message_threads do |t|
      t.string :slug, null: false
      t.text :subject
      t.integer :sender_id, null: false
      t.integer :receiver_id, null: false
      t.datetime :sent_at
      t.timestamps null: false
    end
  end
end
