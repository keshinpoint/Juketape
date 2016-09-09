class CreateSoundcloudNetworks < ActiveRecord::Migration[5.0]
  def change
    create_table :soundcloud_networks do |t|
      t.string :access_token, null: false
      t.string :refresh_token, default: ''
      t.integer :user_id, null: false

      t.timestamps null: false
    end
  end
end
