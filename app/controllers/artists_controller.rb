require 'will_paginate/array'

class ArtistsController < ApplicationController
  before_action :enforce_artist_setup
  skip_before_action :require_login, only: [:dashfolio, :search, :connections]

  def dashfolio
    @artist = if params[:username].present?
      User.find_by_username(params.require(:username))
    else
      current_user
    end
  end

  def fetch_content
    render status: 200,
           partial: 'filter_content_form',
           locals: { content_type: params[:content_type], content: get_content,
            container: params[:container], selected_content: get_selected_content,
            sync_always: get_sync_always} and return
  end

  def filter_content
    params[:sync_always] ||= false
    update_content
  end

  def search
    key = params[:term]
    @name_search = User.where('act_name ILIKE ?', "%#{key}%").uniq.paginate(page: params[:page], per_page: 10)
    @location_search = User.where('location ILIKE ?', "%#{key}%").uniq.paginate(page: params[:page], per_page: 10)
    @tag_search = User.joins(:tags).where('tags.name ILIKE ?', "%#{key}%").uniq.paginate(page: params[:page], per_page: 10)
  end

  def disconnect_network
    if user_network.present?
      user_network.revoke_access if user_network.is_a?(YoutubeNetwork)
      user_network.destroy
    end
    redirect_to :back, notice: 'Successfully disconnected.'
  end

  def connections
    @artist = User.find_by_username(params.require(:username))
    @connections = @artist.connections.paginate(page: params[:page], per_page: 10)
  end

  def feedback
  end

  private
  def get_content
    case params[:content_type]
    when 'instagram_images'
      current_user.instagram_network.all_images
    when 'soundcloud_tracks'
      current_user.soundcloud_network.all_tracks
    when 'soundcloud_albums'
      current_user.soundcloud_network.all_albums
    when 'youtube_videos'
      current_user.youtube_network.all_videos
    when 'facebook_videos'
      current_user.facebook_network.all_videos
    else
      []
    end
  end

  def get_selected_content
    case params[:content_type]
    when 'instagram_images'
      current_user.instagram_network.selected_image_ids
    when 'soundcloud_tracks'
      current_user.soundcloud_network.selected_track_ids
    when 'soundcloud_albums'
      current_user.soundcloud_network.selected_album_ids
    when 'youtube_videos'
      current_user.youtube_network.selected_video_ids
    when 'facebook_videos'
      current_user.facebook_network.selected_video_ids
    else
      []
    end
  end

  def get_sync_always
    case params[:content_type]
    when 'instagram_images'
      current_user.instagram_network.sync_always
    when 'soundcloud_tracks'
      current_user.soundcloud_network.sync_tracks_always
    when 'soundcloud_albums'
      current_user.soundcloud_network.sync_albums_always
    when 'youtube_videos'
      current_user.youtube_network.sync_always
    when 'facebook_videos'
      current_user.facebook_network.sync_always
    else
      false
    end
  end

  def update_content
    items = params[:selected_items] || []
    case params[:content_type]
    when 'instagram_images'
      current_user.instagram_network.update_attributes(selected_images: items, sync_always: params[:sync_always])
    when 'soundcloud_tracks'
      current_user.soundcloud_network.update_attributes(selected_tracks: items, sync_tracks_always: params[:sync_always])
    when 'soundcloud_albums'
      current_user.soundcloud_network.update_attributes(selected_albums: items, sync_albums_always: params[:sync_always])
    when 'youtube_videos'
      current_user.youtube_network.update_attributes(selected_videos: items, sync_always: params[:sync_always])
    when 'facebook_videos'
      current_user.facebook_network.update_attributes(selected_videos: items, sync_always: params[:sync_always])
    else
      true
    end
  end

  def user_network
    @network ||= if params[:network_name] == 'soundcloud'
      current_user.soundcloud_network
    elsif params[:network_name] == 'facebook'
      current_user.facebook_network
    elsif params[:network_name] == 'youtube'
      current_user.youtube_network
    elsif params[:network_name] == 'instagram'
      current_user.instagram_network
    end
  end
end
