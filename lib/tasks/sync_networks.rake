namespace :sync_networks do
  desc "Sync the networks with the updated content"
  task :sync_data => :environment do
    FacebookNetwork.sync_data
    YoutubeNetwork.sync_data
    SoundcloudNetwork.sync_data
    InstagramNetwork.sync_data
  end
end
