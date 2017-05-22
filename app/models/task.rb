class Task < ApplicationRecord
  after_create {TaskAllBoardcastJob.perform_now self}

  belongs_to :user
  belongs_to :room

  has_many :user_tasks, dependent: :destroy
  has_many :users, through: :user_tasks, dependent: :destroy
end
