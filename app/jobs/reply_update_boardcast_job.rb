class ReplyUpdateBoardcastJob < ApplicationJob
  queue_as :default

  def perform reply
    ActionCable.server.broadcast "notify-#{reply.reply_user_id}-channel",
      notify: {type: "reply_message", data: reply}
  end
end
