class UserRoomBoardcastJob < ApplicationJob
  queue_as :default

  def perform user_room
    ActionCable.server.broadcast "notify-#{user_room.user_id}-channel",
      notify: {type: "update_list_rooms"}
  end
end
