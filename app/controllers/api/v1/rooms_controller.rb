class Api::V1::RoomsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :find_room, only: [:show, :update, :destroy]

  def index
    @rooms =  current_user.rooms.order UserRoom.table_name + ".updated_at DESC"
    @rooms = @rooms.as_json user: current_user
  end

  def show
  end

  def create
    @room = current_user.my_created_rooms.new new_rooms_params
    if @room.save
      @room.user_rooms.create user: current_user, room: @room,
        is_accept: true, is_admin: true
      @message = t "rooms.message.create_success", name: @room.name
    else
      @message = t "rooms.message.create_failure"
      render status: :bad_request
    end
  end

  def update
    if @room.update_attributes update_rooms_params
      @message = t "rooms.message.update_success", name: @room.name
    else
      @message = t "rooms.message.update_failure"
      render status: :bad_request
    end
  end

  def destroy
    if @room.can_destroy_by_user current_user
      @room.destroy
      @message = t "rooms.message.destroy_success"
    else
      @message = t "rooms.message.destroy_failure"
      render status: :bad_request
    end
  end

  protected
  def find_room
    @room = current_user.rooms.find_by id: params[:id]
    unless @room
      render json: {message: t("rooms.room_not_found")}, status: 404
    end
  end

  def new_rooms_params
    params.require(:room).permit :name, :description, :room_type
  end

  def update_rooms_params
    params.require(:room).permit :name, :description
  end
end
