class NotifyChannel < ApplicationCable::Channel
  def subscribed
    @channel_id = current_user.id
    stream_from "notify-#{@channel_id}-channel"
  end
end
