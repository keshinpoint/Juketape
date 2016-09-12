class TimelineEventsController < ApplicationController

  def create
    event = current_user.timeline_events.new(event_params)
    if event.save
      flash.now[:notice] = 'Event added successfully'
      redirect_to dashfolio_artists_path
    else
      if request.xhr?
        render status: 422,
          partial: 'shared/error_response',
          locals: { message: event.errors.full_messages.join('<br/>') } and return
      end
    end
  end

  def update
    if event.update_attributes(event_params)
      render json: {message: 'Details updates successfully'}, status: 202
    else
      render json: {error: event.errors.full_messages.join(',')}, status: 404
    end
  end

  private

  def event
    @event ||= current_user.timeline_events.find(params.require(:id))
  end

  def event_params
    params.require(:timeline_event).permit(:title, :description,
      :start_date, :end_date, :location, :at_present)
  end
end
