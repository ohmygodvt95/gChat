class User < ApplicationRecord
  has_many :user_rooms, dependent: :destroy
  has_many :user_tasks, dependent: :destroy
  has_many :rooms, through: :user_rooms, dependent: :destroy
  has_many :my_created_rooms, class_name: Room.name, dependent: :destroy
  has_many :mentions, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_many :has_been_mentions, class_name: Mention.name, foreign_key: :mention_user_id
  has_many :has_been_replies, class_name: Reply.name, foreign_key: :reply_user_id
  has_many :tasks, through: :user_tasks, dependent: :destroy
  has_many :my_created_tasks, class_name: Task.name, dependent: :destroy

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
end
