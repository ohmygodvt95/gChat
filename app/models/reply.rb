class Reply < ApplicationRecord
  after_create {ReplyBoardcastJob.perform_now self}
  after_update :update_is_read, if: :is_read_changed?

  belongs_to :user
  belongs_to :room
  belongs_to :message

  has_one :reply_user, class_name: User.name,
    foreign_key: :reply_user_id
  has_one :reply_message, class_name: Message.name,
    foreign_key: :reply_message_id

  protected
  def update_is_read
    ReplyUpdateBoardcastJob.perform_now self
  end
end
