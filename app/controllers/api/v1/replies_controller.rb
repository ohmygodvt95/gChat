class Api::V1::RepliesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :find_room, only: :update
  before_action :find_message, only: :update
  before_action :find_reply, only: :update

  def update
    @reply.update_attributes update_params
  end

  protected
  def find_room
    @room = current_user.rooms.find_by id: params[:room_id]
    unless @room
      render json: {message: t("rooms.room_not_found")}, status: 404
    end
  end

  def find_message
    @message = @room.messages.find_by id: params[:message_id]
    unless @message
      render json: {message: t("rooms.message_not_found")}, status: 404
    end
  end

  def find_reply
    @reply = @message.replies.find_by id: params[:id]
    unless @reply
      render json: {message: t("rooms.message_not_found")}, status: 404
    end
  end

  def update_params
    params.require(:reply).permit :is_read
  end
end
