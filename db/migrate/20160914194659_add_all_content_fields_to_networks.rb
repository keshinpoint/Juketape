class AddAllContentFieldsToNetworks < ActiveRecord::Migration[5.0]
  def change
    add_column :youtube_networks, :all_videos, :json, array: true, default: []
    add_column :facebook_networks, :all_videos, :json, array: true, default: []
    add_column :instagram_networks, :all_images, :json, array: true, default: []
    add_column :soundcloud_networks, :all_tracks, :json, array: true, default: []
    add_column :soundcloud_networks, :all_albums, :json, array: true, default: []
  end
end
