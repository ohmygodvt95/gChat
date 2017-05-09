class Relationship < ApplicationRecord
  after_create_commit :notify_new_request_contact
  before_save :create_private_room, if: :is_accept_changed?
  after_destroy :destroy_private_room

  belongs_to :user_request, class_name: User.name,
    foreign_key: :user_request_id
  belongs_to :user_receiver, class_name: User.name,
    foreign_key: :user_receiver_id

  scope :request_contact,
    ->(user_id){where user_receiver_id: user_id, is_accept: false}

  scope :exist_contact,
    ->(user_id){where(user_receiver_id: user_id[0], user_request_id: user_id[1])
      .or(where user_receiver_id: user_id[1], user_request_id: user_id[0])}

  def create_private_room
    self.private_room_id = PrivateRoomService.new(relationship: self)
      .create_private_room
    PrivateRoomCreatedBoardcastJob.perform_now self
  end

  def destroy_private_room
    room = Room.find_by id: self.private_room_id
    room.destroy
  end

  def notify_new_request_contact
    RequestContactBoardcastJob.perform_now self
  end
end
