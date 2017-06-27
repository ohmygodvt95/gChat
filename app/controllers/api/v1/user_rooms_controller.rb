class Api::V1::UserRoomsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :find_room, only: :update
  before_action :find_user_room, only: :update

  def update
    @user_room.update_attributes focus_at: Time.now
  end

  protected
  def find_room
    @room = current_user.rooms.find_by id: params[:room_id]
    unless @room
      render json: {message: t("rooms.room_not_found")}, status: 404
    end
  end

  def find_user_room
    @user_room = @room.user_rooms.find_by user_id: current_user.id
    unless @user_room
      render json: {message: t("rooms.message_not_found")}, status: 404
    end
  end
end
