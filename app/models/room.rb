class Room < ApplicationRecord
  belongs_to :user

  has_many :user_rooms, dependent: :destroy
  has_many :users, through: :user_rooms, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :tasks, dependent: :destroy
end
