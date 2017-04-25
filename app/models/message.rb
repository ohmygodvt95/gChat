class Message < ApplicationRecord
  belongs_to :room
  belongs_to :user

  has_many :replies, dependent: :destroy
  has_many :mentions, dependent: :destroy
end
