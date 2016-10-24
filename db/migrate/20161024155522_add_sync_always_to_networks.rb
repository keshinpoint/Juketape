class AddSyncAlwaysToNetworks < ActiveRecord::Migration[5.0]
  def change
    add_column :youtube_networks, :sync_always, :boolean, default: false
    add_column :facebook_networks, :sync_always, :boolean, default: false
    add_column :instagram_networks, :sync_always, :boolean, default: false
    add_column :soundcloud_networks, :sync_tracks_always, :boolean, default: false
    add_column :soundcloud_networks, :sync_albums_always, :boolean, default: false
  end
end
