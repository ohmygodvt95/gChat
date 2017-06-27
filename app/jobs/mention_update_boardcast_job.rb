class MentionUpdateBoardcastJob < ApplicationJob
  queue_as :default

  def perform mention
    ActionCable.server.broadcast "notify-#{mention.mention_user_id}-channel",
    notify: {type: "mention_user", data: mention}
  end
end
