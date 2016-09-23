class NotificationsController < ApplicationController

  def index
    @pending_invitations = current_user.pending_invitations
  end
end
