class TaskDestroyBoardcastJob < ApplicationJob
  queue_as :default

  def perform task
    task.users.each do |user|
      ActionCable.server.broadcast "notify-#{user.id}-channel",
        notify: {
         type: "delete_task"
        }
    end
    ActionCable.server.broadcast "room-#{task.room_id}-channel",
      notify: {
       type: "delete_task"
      }
  end
end
