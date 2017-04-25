class Reply < ApplicationRecord
  belongs_to :user
  belongs_to :room
  belongs_to :message

  has_one :reply_user, class_name: User.name,
    foreign_key: :reply_user_id
  has_one :reply_message, class_name: Message.name,
    foreign_key: :reply_message_id
end
