require 'koala'
class FacebookNetwork < ApplicationRecord

  belongs_to :user
  validates :token, presence: true

  def load_facebook
    @graph ||= Koala::Facebook::API.new(fb_token)
  end

  def load_facebook_page
    @page ||= Koala::Facebook::API.new(get_page_token)
  end

  def facebook_pages
    @pages ||= fb_pages
  end

  def all_videos
    @all_videos ||= videos
  end

  def user_videos
    return all_videos if selected_items.blank?
    all_videos.select { |x| selected_items.include?(x[:id].to_s) }
  end

  def stats
    begin
      page = load_facebook_page.get_object('me')
      {
        likes_count: page['likes'],
        videos_count: user_videos.count
      }
    rescue
      return {}
    end
  end

  private

  # This is the token of the facebook, and this method can be removed once the 
  # offline access for the application has been granted by the facebook api.
  def fb_token
    # token
    ENV['FB_TOKEN']
  end

  def get_page_token
    return fb_token unless page_id.present?
    load_facebook.get_page_access_token(page_id)
  end

  def videos
    begin
      videos = load_facebook_page.get_connections('me', 'videos')
      videos.map do |video|
        {
          id: video['id'],
          name: video['name'],
          picture: video['picture'],
          source: video['source'],
          updated_time: video['updated_time']
        }
      end
    rescue
      return []
    end
  end

  def fb_pages
    begin
      pages = load_facebook.get_connections('me', 'accounts')
      pages.delete_if {|page| page['category'].eql?('Application')}
      pages.map do |page|
        {
          id: page['id'],
          name: page['name'],
          access_token: page['access_token']
        }
      end
    rescue
      return []
    end
  end
end
