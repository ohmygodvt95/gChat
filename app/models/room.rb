class Room < ApplicationRecord
  belongs_to :user

  has_many :user_rooms, dependent: :destroy
  has_many :users, through: :user_rooms, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :tasks, dependent: :destroy

  def room_name current_user
    if self.room_type.eql? "private"
      user = self.users.user_for_private_room current_user.id
      user.username
    else
      self.name
    end
  end

  def can_destroy_by_user user
    user_room = self.user_rooms.find_by user_id: user.id
    user_room.is_admin
  end

  def as_json options = {}
    json = super options
    json["name"] = room_name options[:user]
    json
  end
end
