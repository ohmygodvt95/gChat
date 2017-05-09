class RequestContactBoardcastJob < ApplicationJob
  queue_as :default

  def perform relationship
    ActionCable.server.broadcast "notify-#{relationship.user_receiver_id}-channel",
      notify: {type: "new_request_contact"}
  end
end
