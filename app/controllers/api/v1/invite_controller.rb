class Api::V1::InviteController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :find_room, only: [:create]
  before_action :find_params, only: [:create]
  before_action :find_user, only: [:create]
  before_action :user_in_room, only: [:create]

  def create
    user_room = @room.user_rooms.build room_id: @room.id, user_id: @user.id
    if user_room.save
      @message = t "rooms.invite_success", name: @user.username
    end
  end

  protected
  def find_params
    params.require(:invite).permit :email
  end

  def find_room
    @room = current_user.rooms.find_by id: params[:room_id]
    unless @room
      render json: {message: t("rooms.room_not_found")}, status: 404
    end
  end

  def find_user
    @user = User.find_by email: params[:invite][:email]
    unless @user
      render json: {message: t("contacts.message.user_not_found")}, status: 404
    end
  end

  def user_in_room
    if @room.users.include? @user
      render json: {message: t("rooms.user_in_room", name: @user.username)}, status: 404
    end
  end
end
