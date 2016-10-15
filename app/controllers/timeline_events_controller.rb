class TimelineEventsController < ApplicationController

  def create
    @event = artist.timeline_events.create(event_params)
    unless @event.valid?
      render status: 422,
        partial: 'shared/error_response',
        locals: { message: @event.errors.full_messages.join('<br/>') } and return
    end
  end

  def update
    if event.update_attributes(event_params)
      render json: {message: 'Details updates successfully'}, status: 202
    else
      render json: {error: event.errors.full_messages.join(',')}, status: 404
    end
  end

  def destroy
    event.destroy if event.present?
    if request.xhr?
      render 'create'
    end
  end

  private

  def event
    @event ||= artist.timeline_events.find(params.require(:id))
  end

  def artist
    @artist ||= current_user
  end

  def event_params
    params.require(:timeline_event).permit(:title, :description,
      :start_date, :end_date, :location, :at_present)
  end
end
