class AddDisplayNameToNetworks < ActiveRecord::Migration[5.0]
  def change
    add_column :youtube_networks, :display_name, :string
    add_column :facebook_networks, :display_name, :string
    add_column :instagram_networks, :display_name, :string
    add_column :soundcloud_networks, :display_name, :string
  end
end
