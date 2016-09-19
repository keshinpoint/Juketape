class TagsController < ApplicationController

  def create
    tag = current_user.tags.create(name: params.require(:name))
    unless tag.valid?
      render json: { error: "Failed to add Tag" }, status: 424
    end
  end

  def destroy
    tag = Tag.find(params.require(:id))
    tag.destroy
  end
end
