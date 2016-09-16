class AddSelectedContentFields < ActiveRecord::Migration[5.0]
  def change
    add_column :youtube_networks, :selected_videos, :string, array: true, default: []
    add_column :facebook_networks, :selected_videos, :string, array: true, default: []
    add_column :instagram_networks, :selected_images, :string, array: true, default: []
    add_column :soundcloud_networks, :selected_tracks, :string, array: true, default: []
    add_column :soundcloud_networks, :selected_albums, :string, array: true, default: []
  end
end
