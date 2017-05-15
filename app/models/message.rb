class Message < ApplicationRecord
  after_commit {MessageCreatedBoardcastJob.perform_now self}

  belongs_to :room
  belongs_to :user

  has_many :replies, dependent: :destroy
  has_many :mentions, dependent: :destroy
end
