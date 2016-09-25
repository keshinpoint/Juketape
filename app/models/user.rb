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
  has_many :invitations, foreign_key: :initiator_id
  has_many :accepted_invitations_as_initiator, -> { where(status: Invitation.statuses[:accepted]) },
    class_name: 'Invitation', foreign_key: :initiator_id
  has_many :pending_invitations, -> { where(status: Invitation.statuses[:pending]) },
    class_name: 'Invitation', foreign_key: :invitee_id
  has_many :accepted_invitations_as_invitee, -> { where(status: Invitation.statuses[:accepted]) },
    class_name: 'Invitation', foreign_key: :invitee_id
  has_many :invited_connections, through: :accepted_invitations_as_invitee, source: :initiator
  has_many :initiated_connections, through: :accepted_invitations_as_initiator, source: :invitee

  def email_optional?
    true
  end

  def connections
    invited_connections + initiated_connections
  end

  def is_connected_to?(friend)
    connections.include?(friend)
  end

  def already_invited?(friend)
    invited_friends.include?(friend)
  end

  def invited_friends
    invitations.map(&:invitee) + pending_invitations.map(&:initiator)
  end

  def ordered_timeline_events
    timeline_events.order('end_date DESC NULLS FIRST')
  end

  def self.authenticate(username, password)
    return nil  unless user = find_by_username(username)
    return user if     user.authenticated?(password)
  end

  def message_threads
    MessageThread.where('message_threads.sender_id = ? or message_threads.receiver_id = ?', self.id, self.id).order(last_reply_at: :desc)
  end

  def recent_thread
    message_threads.first
  end

end
