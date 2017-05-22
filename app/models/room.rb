class Room < ApplicationRecord
  before_destroy {PrivateRoomDestroyBoardcastJob.perform_now self}
  after_update {RoomInfoBoardcastJob.perform_now self}

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
    json["is_admin"] = is_admin_room? options[:user]
    json["list_admin"] = list_admin
    json["list_members"] = list_members
    json["reply_count"] = reply_count options[:user]
    json["mention_count"] = mention_count options[:user]
    json
  end

  protected
  def is_admin_room? user
    user_room = user_rooms.find_by user_id: user.id
    user_room.is_admin
  end

  def list_admin
    admin = user_rooms.where is_admin: true
    admin.map &:user
  end

  def list_members
    members = user_rooms.where is_admin: false
    members.map &:user
  end

  def reply_count user
    replies = Reply.where reply_user_id: user.id, room_id: self.id,
      is_read: false
    replies.count
  end

  def mention_count user
    mentions = Mention.where mention_user_id: user.id, room_id: self.id,
      is_read: false
    mentions.count
  end
end
