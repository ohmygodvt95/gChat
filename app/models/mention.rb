class Mention < ApplicationRecord
  belongs_to :user
  belongs_to :room
  belongs_to :message

  has_one :mention_user, class_name: User.name, foreign_key: :mention_user_id
end
