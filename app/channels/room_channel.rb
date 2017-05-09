class RoomChannel < ApplicationCable::Channel
  def subscribed
    @channel_id = params[:data][:room_id]
    stream_from "room-#{@channel_id}-channel"
  end
end
