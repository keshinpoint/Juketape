class TagsController < ApplicationController

  def create
    @artist = current_user
    tag = @artist.tags.create(name: params.require(:name))
    unless tag.valid?
      render json: { error: "Failed to add Tag" }, status: 424
    end
  end

  def destroy
    @artist = current_user
    tag = Tag.find(params.require(:id))
    tag.destroy
  end
end
