class ArtistsController < ApplicationController
  before_action :enforce_artist_setup

  def dashfolio
    @artist = current_user
  end
end