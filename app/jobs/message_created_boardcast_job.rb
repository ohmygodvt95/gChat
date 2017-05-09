class MessageCreatedBoardcastJob < ApplicationJob
  queue_as :default

  def perform message
    ActionCable.server.broadcast "room-#{message.room_id}-channel",
      notify: {
        type: "new_message",
        message: message.as_json(include: :user)
      }
  end
end
