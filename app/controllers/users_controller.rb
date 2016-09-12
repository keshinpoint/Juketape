class UsersController < ApplicationController

  def update
    if current_user.update_attributes(user_params)
      render json: {message: 'Details updates successfully'}, status: 202
    else
      render json: {error: current_user.errors.full_messages.join(',')}, status: 404
    end
  end

  private

  def user_params
    params.require(:user).permit(:act_name, :tag_line, :location)
  end
end
