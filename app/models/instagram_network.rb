require 'instagram'
class InstagramNetwork < ApplicationRecord
  belongs_to :user
  validates :access_token, presence: true
  after_create :fetch_and_update_all_images, :update_display_name

  def load_instagram
    @client ||= Instagram.new(access_token: access_token)
  end

  def user_info
    load_instagram.get_user
  end

  def images
    return all_images if sync_always?
    all_images.select {|image| selected_images.include?(image['id'])}
  end

  def selected_image_ids
    return selected_images unless sync_always?
    all_images.map { |i| i['id'].to_s }
  end

  def self.sync_data
    puts "***** Syncing data for Instagram on #{Date.current} *****"
    all.each do |network|
      network.update_attributes(all_images: network.get_images)
    end
    puts "***** Done for Instagram *****"
  end

  def get_images
    load_instagram.all_images.map do |image|
      {
        id: image['id'],
        link: image['link'],
        url: image['images']['standard_resolution']['url'],
        user_full_name: image['user']['full_name'],
        user_id: image['user']['id'],
        username: image['user']['username']
      }
    end
  end

  private
  def fetch_and_update_all_images
    self.update_attributes(all_images: get_images)
  end

  def update_display_name
    self.update_attributes(display_name: user_info['username'])
  end
end
