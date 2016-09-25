class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :body, null: false
      t.boolean :seen,default: false
      t.integer :sender_id, null: false
      t.integer :message_thread_id, null: false
      t.datetime :sent_at
      t.timestamps null: false
    end
  end
end
