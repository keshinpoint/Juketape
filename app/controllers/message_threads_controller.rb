class MessageThreadsController < ApplicationController

  def new
    @receiver = User.find_by_username(params.require(:username))
  end

  def create
    @receiver = User.find_by_username(params.require(:receiver))
    thread = MessageThread.create(thread_attrs)
    if thread.valid?
      flash[:notice] = "Message has sent successfully to #{@receiver.act_name}"
      redirect_to artist_dashfolio_path(username: @receiver.username)
    else
      flash[:notice] = thread.errors.full_messages.join(', ')
      render 'new'
    end
  end

  def index
    current_user.update_attributes(message_notif_count: 0) if
      current_user.message_notif_count > 0
    if current_user.recent_thread.present?
      redirect_to message_show_path(slug: current_user.recent_thread.slug)
    end
  end

  def show
    @thread = current_user.message_threads.find_by_slug(params.require(:slug))
    last_msg = @thread.last_message
    last_msg.seen! unless last_msg.sender == current_user
  end

  def add_reply
    @thread = MessageThread.find_by_slug(params.require(:slug))
    @message = @thread.messages.create({
      body: params.require(:body),
      sender_id: current_user.id,
      sent_at: Time.current,
      receiver_id: @thread.sender_id == current_user.id ?
        @thread.receiver_id :
        @thread.sender_id
    })
    unless @message.valid?
      render json: { error: "Failed to send reply" }, status: 424
    end
  end

  def destroy
    thread = current_user.message_threads.find_by_slug(params.require(:slug))
    attrs = if thread.sender_id == current_user.id
      { deleted_by_sender: true, deleted_id_by_sender: thread.last_message.id }
    else
      { deleted_by_receiver: true, deleted_id_by_receiver: thread.last_message.id }
    end
    thread.update_attributes(attrs)
    redirect_to artist_inbox_path()
  end

  private
  def thread_attrs
    {
      subject: params.require(:subject),
      sender_id: current_user.id,
      receiver_id: @receiver.id,
      sent_at: Time.current,
      messages_attributes: [{
        body: params.require(:body),
        sender_id: current_user.id,
        sent_at: Time.current,
        receiver_id: @receiver.id
      }]
    }
  end

end
