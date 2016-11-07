class SettingsController < ApplicationController
  before_action :set_partial_name, only: [:act_name, :user_location, :email, :change_password]

  def index
  end

  def act_name
    current_user.update_attributes(user_attrs(:act_name))
    render 'update_user' if request.xhr?
  end

  def user_location
    current_user.update_attributes(user_attrs(:location))
    render 'update_user' if request.xhr?
  end

  def profile_pic
    current_user.update_attributes(user_attrs(:image))
    redirect_to settings_path, notice: 'Profile pic updated successfully.'
  end

  def email
    current_user.update_attributes(user_attrs(:email))
    render 'update_user' if request.xhr?
  end

  def change_password
    resp = current_user.update_password!(update_pwd_attrs)
    sign_in current_user if resp == true
    render 'update_user' if request.xhr?
  end

  def fb_page
    network = current_user.facebook_network
    network.update_fb_page(params.require(:page_id)) if
      current_user.facebook_network.present?
    redirect_to :back
  end

  private
  def set_partial_name
    @partial_name = action_name.to_s
  end

  def user_attrs(field)
    params.require(:user).permit(field)
  end

  def update_pwd_attrs
    params.permit(:current_password, :new_password, :confirm_password)
  end

end
