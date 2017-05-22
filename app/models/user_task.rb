class UserTask < ApplicationRecord
  after_create {TaskBoardcastJob.perform_now self}
  after_update :update_status, if: :is_completed_changed?

  belongs_to :user
  belongs_to :task

  protected
  def update_status
    TaskBoardcastJob.perform_now self
    TaskAllBoardcastJob.perform_now task
  end
end
