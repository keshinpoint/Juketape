class InvitationsController < ApplicationController
  skip_before_action :require_login, only: [:request_invite]

  def invite
    @invitee = User.find_by_username(params.require(:username))
    unless can_connect_with?(current_user, @invitee)
      flash[:notice] = "You can not send invitation request to this artist #{@invitee.act_name}"
      redirect_to dashfolio_artists_path()
    end
  end

  def invitation_page
  end

  def send_invitations
    current_user.send_invitations(params.require(:emails))
    redirect_to invitation_page_artist_path, notice: 'Successfully sent invitations to given emails'
  end

  def create
    invitee = User.find_by_username(params.require(:invitee))
    invitation = current_user.invitations.create({
      invitee_id: invitee.id,
      known_by: params.require(:invitation)[:known_by],
      welcome_message: params.require(:invitation)[:welcome_message],
      sent_at: Date.current
    })
    if invitation.valid?
      UserMailer.connection_request_email(invitation, current_user, invitee).deliver_now
      flash[:notice] = "Connection request to #{invitee.act_name} has sent successfully"
      redirect_to artist_dashfolio_path(username: invitee.username)
    else
      flash[:notice] = invitation.errors.full_messages.join(', ')
      render 'invite'
    end
  end

  def accept
    invitation.accepted!
    flash[:notice] = "Connection accepted successfully"
    redirect_to notifications_path
  end

  def reject
    # invitation.rejected!
    invitation.destroy
    flash[:notice] = "Connection rejected successfully"
    redirect_to notifications_path
  end

  def disconnect
    artist = User.find_by_username(params.require(:with_artist))
    invitation = current_user.invitation_with(artist)
    invitation.destroy
    redirect_to artist_dashfolio_path(username: artist.username)
  end

  def request_invite
    UserMailer.send_requested_invitation(params.require(:email)).deliver_now
    redirect_to root_path(), notice: 'We have recieved your request, and you will hear from us soon.'
  end

  private
  def invitation
    current_user.pending_invitations.find(params.require(:id))
  end
end
