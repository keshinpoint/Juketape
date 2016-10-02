class InvitationsController < ApplicationController

  def invite
  end

  def create
    invitee = User.find_by_username(params.require(:invitee))
    invitation = current_user.invitations.create({
      invitee_id: invitee.id,
      known_by: params.require(:invitation)[:known_by],
      sent_at: Date.current
    })
    if invitation.valid?
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
    invitation.rejected!
    flash[:notice] = "Connection rejected successfully"
    redirect_to notifications_path
  end

  def disconnect
    artist = User.find_by_username(params.require(:with_artist))
    invitation = current_user.invitation_with(artist)
    invitation.destroy
    redirect_to artist_dashfolio_path(username: artist.username)
  end

  private
  def invitation
    current_user.pending_invitations.find(params.require(:id))
  end
end
