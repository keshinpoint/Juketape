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
  before_validation :generate_invite_code, on: :create

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

  def update_password!(attrs)
    if authenticated?(attrs[:current_password])
      if attrs[:new_password] == attrs[:confirm_password]
        self.password = attrs[:new_password]
        self.save
      else
        errors.add(:base, 'Please enter confirm password same as new password')
        false
      end
    else
      errors.add(:base, 'Please enter correct password')
      false
    end
  end

  def message_threads
    MessageThread.where('(sender_id = ? and deleted_by_sender = ?) or (receiver_id = ? and deleted_by_receiver = ?)', id, false, id, false).order(last_reply_at: :desc)
  end

  def recent_thread
    message_threads.first
  end

  def invitation_with(artist)
    Invitation.where('(initiator_id = ? AND invitee_id = ?) OR (initiator_id = ? AND invitee_id = ?)', id, artist.id, artist.id, id).first
  end

  def send_invitations(emails)
    UserMailer.invitation_email(self, emails).deliver_now
  end

  private

  def generate_invite_code
    self.invite_code = SecureRandom.urlsafe_base64(6)
    generate_invite_code if User.exists?(invite_code: invite_code)
  end
end
