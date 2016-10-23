class NotificationsController < ApplicationController

  def index
    current_user.update_attributes(connection_notif_count: 0) if
      current_user.connection_notif_count > 0
    @pending_invitations = current_user.pending_invitations
  end
end
