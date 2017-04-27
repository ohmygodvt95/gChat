class PrivateRoomService
  attr_reader :params

  def initialize params
    @relationship = params[:relationship]
  end

  def create_private_room
    room = Room.create user_id: @relationship.user_request_id,
      room_type: :private
    room.user_rooms.create user_id: @relationship.user_request_id,
      room_id: room.id, is_accept: true, is_admin: true
    room.user_rooms.create user_id: @relationship.user_receiver_id,
      room_id: room.id, is_accept: true, is_admin: true
    room.id
  end
end
