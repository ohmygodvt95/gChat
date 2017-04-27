class PrivateRoomDestroyBoardcastJob < ApplicationJob
  queue_as :default

  def perform room
    room.users.each do |user|
      ActionCable.server.broadcast "notify-#{user.id}-channel",
      notify: {type: "update_list_rooms"}
    end
    room.destroy
  end
end
