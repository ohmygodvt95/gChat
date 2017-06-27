class TaskBoardcastJob < ApplicationJob
  queue_as :default

  def perform task
    ActionCable.server.broadcast "notify-#{task.user_id}-channel",
      notify: {type: "new_task"}
  end
end
