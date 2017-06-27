class Api::V1::LeavesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :find_room, only: :destroy
  before_action :user_in_room, only: :destroy

  def destroy
    if @room.users.delete current_user
      @message = t "rooms.leave_success"
    else
      @message = t "rooms.leave_failure"
      render status: 500
    end
  end

  protected
  def find_room
    @room = current_user.rooms.find_by id: params[:room_id]
    unless @room
      render json: {message: t("rooms.room_not_found")}, status: 404
    end
  end

  def user_in_room
    unless @room.users.include? current_user
      render json:
        {message: t("rooms.user_not_in_room", name: current_user.username)},
        status: 404
    end
  end
end
