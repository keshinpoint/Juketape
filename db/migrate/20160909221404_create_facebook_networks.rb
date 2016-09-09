class CreateFacebookNetworks < ActiveRecord::Migration[5.0]
  def change
    create_table :facebook_networks do |t|
      t.string :token, default: ''
      t.string :secret, default: ''
      t.string :page_token, default: ''
      t.integer :user_id, null: false

      t.timestamps null: false
    end
  end
end
