require 'koala'
class FacebookNetwork < ApplicationRecord

  belongs_to :user
  validates :token, presence: true
  after_create :fetch_and_update_pages_and_videos, :update_display_name

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
    @all_videos ||= get_videos
  end

  def videos
    all_videos.select {|video| selected_videos.include?(video['id'])}
  end

  def user_videos
    return all_videos if selected_items.blank?
    all_videos.select { |x| selected_items.include?(x[:id].to_s) }
  end

  def user_info
    load_facebook_page.get_object('me')
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

  def update_fb_page(p_id)
    self.page_id = p_id
    self.all_videos = get_videos
    save
  end

  def self.sync_data
    puts "***** Syncing data for Facebook on #{Date.current} *****"
    all.each do |network|
      network.send(:fetch_and_update_pages_and_videos)
    end
    puts '***** Done for Facebook *****'
  end

  private

  def fetch_and_update_pages_and_videos
    self.all_pages = fb_pages
    self.all_videos = get_videos
    save
  end

  def update_display_name
    self.update_attributes(display_name: user_info['name'])
  end

  # This is the token of the facebook, and this method can be removed once the 
  # offline access for the application has been granted by the facebook api.
  def fb_token
    token
    # ENV['FB_TOKEN']
  end

  def get_page_token
    return fb_token unless page_id.present?
    load_facebook.get_page_access_token(page_id)
  end

  def get_videos
    begin
      videos = load_facebook_page.get_connections('me', 'videos?limit=10000')
      videos.map do |video|
        {
          'id' => video['id'],
          'name' => video['name'],
          'url' => "http://www.facebook.com/video/embed?video_id=#{video['id']}"
        }
      end
    rescue
      return []
    end
  end

  def fb_pages
    begin
      pages = load_facebook.get_connections('me', 'accounts?limit=100')
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
