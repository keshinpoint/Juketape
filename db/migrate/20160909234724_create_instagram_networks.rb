class CreateInstagramNetworks < ActiveRecord::Migration[5.0]
  def change
    create_table :instagram_networks do |t|
      t.string :access_token, default: ''
      t.integer :user_id, null: false

      t.timestamps null: false
    end
  end
end
