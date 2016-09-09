class CreateYoutubeNetworks < ActiveRecord::Migration[5.0]
  def change
    create_table :youtube_networks do |t|
      t.string :access_token, default: ''
      t.string :refresh_token, default: ''
      t.string :expires_in, default: ''
      t.integer :user_id, null: false

      t.timestamps null: false
    end
  end
end
