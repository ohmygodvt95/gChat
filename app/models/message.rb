class Message < ApplicationRecord
  after_commit {MessageCreatedBoardcastJob.perform_now self}

  belongs_to :room
  belongs_to :user

  has_many :replies, dependent: :destroy
  has_many :mentions, dependent: :destroy

  scope :order_by_id_desc, ->{order(id: :desc).limit Settings.msg_limit}
  scope :from_by_id, ->(id){where("id < ?", id).order(id: :desc)
    .limit Settings.msg_limit}
end
