class MessageDestroyBoardcastJob < ApplicationJob
  queue_as :default

  def perform message
    ActionCable.server.broadcast "room-#{message.room_id}-channel",
      notify: {
        type: "destroy_message",
        message: message
      }
  end
end
