class PrivateRoomCreatedBoardcastJob < ApplicationJob
  queue_as :default

  def perform relationship
    ActionCable.server.broadcast "notify-#{relationship.user_receiver_id}-channel",
      notify: {type: "update_list_rooms"}
    ActionCable.server.broadcast "notify-#{relationship.user_request_id}-channel",
      notify: {type: "update_list_rooms"}
  end
end
