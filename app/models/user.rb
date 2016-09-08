class User < ApplicationRecord
  include Clearance::User
  mount_uploader :image, ImageUploader

  validates :username, :email, presence: true, uniqueness: true

  def email_optional?
    true
  end

  def self.authenticate(username, password)
    return nil  unless user = find_by_username(username)
    return user if     user.authenticated?(password)
  end

end
