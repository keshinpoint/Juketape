class User < ApplicationRecord
  include Clearance::User
  mount_uploader :image, ImageUploader

  validates :username, :email, presence: true, uniqueness: true
  validates :tag_line, :act_name, presence: true, if: :finalized_setup?
  has_one :soundcloud_network
  has_one :youtube_network
  has_one :facebook_network
  has_one :instagram_network
  has_many :timeline_events
  has_many :tags

  def email_optional?
    true
  end

  def ordered_timeline_events
    timeline_events.order('end_date DESC NULLS FIRST')
  end

  def self.authenticate(username, password)
    return nil  unless user = find_by_username(username)
    return user if     user.authenticated?(password)
  end

end
