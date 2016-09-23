class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.integer :initiator_id, null: false
      t.integer :invitee_id, null: false
      t.boolean :accepted
      t.string :known_by
      t.date :sent_at
      t.timestamps null: false
    end
  end
end
