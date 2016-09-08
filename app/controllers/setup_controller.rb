class SetupController < ApplicationController

  def act_name
    flash[:notice] = 'Please complete your one time Profile setup wizard configuration'
  end

  def tag_line
    if request.post?
      current_user.update_attributes(user_attrs(:act_name))
      flash[:notice] = 'Act Name updated successfully.'
    end
  end

  def profile_pic
    if request.post?
      current_user.update_attributes(user_attrs(:tag_line))
      flash[:notice] = 'Tagline updated successfully.'
    end
  end

  def social_media
    if request.post?
      current_user.update_attributes(user_attrs(:image))
      flash[:notice] = 'Profile Picture updated successfully.'
    end
  end

  def finalize_setup
    current_user.update_attributes(finalized_setup: true)
    redirect_to dashfolio_artists_path()
  end

  private
  def user_attrs(field)
    params.require(:user).permit(field)
  end
end
