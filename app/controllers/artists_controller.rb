class ArtistsController < ApplicationController
  before_action :enforce_artist_setup
  skip_before_action :require_login, only: [:dashfolio, :search]

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
           locals: { content_type: params[:content_type], content: get_content, container: params[:container] } and return
  end

  def filter_content
    update_content
  end

  def search
    key = params[:search]
    @name_search = User.where('act_name ILIKE ?', "%#{key}%").uniq.paginate(page: params[:page], per_page: 2)
    @tag_search = User.joins(:tags).where('tags.name ILIKE ?', "%#{key}%").uniq.paginate(page: params[:page], per_page: 10)
  end

  def disconnect_network
    if user_network.present?
      user_network.revoke_access if user_network.is_a?(YoutubeNetwork)
      user_network.destroy
    end
    redirect_to :back, notice: 'Successfully disconnected.'
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
    else
      []
    end
  end

  def update_content
    items = params.require(:selected_items)
    case params[:content_type]
    when 'instagram_images'
      current_user.instagram_network.update_attributes(selected_images: items)
    when 'soundcloud_tracks'
      current_user.soundcloud_network.update_attributes(selected_tracks: items)
    when 'soundcloud_albums'
      current_user.soundcloud_network.update_attributes(selected_albums: items)
    when 'youtube_videos'
      current_user.youtube_network.update_attributes(selected_videos: items)
    when 'facebook_videos'
      current_user.facebook_network.update_attributes(selected_videos: items)
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
