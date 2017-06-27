class TaskAllBoardcastJob < ApplicationJob
  queue_as :default

  def perform task
    ActionCable.server.broadcast "room-#{task.room_id}-channel",
       notify: {
         type: "new_task"
       }
  end
end
