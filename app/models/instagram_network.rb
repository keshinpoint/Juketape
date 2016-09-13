require 'instagram'
class InstagramNetwork < ApplicationRecord
  belongs_to :user
  validates :access_token, presence: true

  def load_instagram
    @client ||= Instagram.new(access_token: access_token)
  end

  def user_info
    load_instagram.get_user
  end

  def images
    load_instagram.recent_images.map do |image|
      {
        link: image['link'],
        url: image['images']['standard_resolution']['url'],
        user_full_name: image['user']['full_name'],
        user_id: image['user']['id'],
        username: image['user']['username']
      }
    end
  end
end
