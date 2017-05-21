class Api::V1::MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :find_room, except: [:new, :edit]
  before_action :find_message, only: [:destroy]

  def index
    from = params[:from].to_i
    if from == 0
      @messages = @room.messages.order_by_id_desc
    else
      @messages = @room.messages.from_by_id
    end
  end

  def create
    @message = @room.messages.new new_message_params
      .merge user_id: current_user.id
    unless @message.save
      @msg = t "rooms.create_message_failure"
      render status: 500
    end
  end

  def destroy
    if @message.destroy
      @message = t "rooms.message_delete_succees"
    else
      @message = t "rooms.message_delete_failure"
    end
  end

  protected
  def find_room
    @room = current_user.rooms.find_by id: params[:room_id]
    unless @room
      render json: {message: t("rooms.room_not_found")}, status: 404
    end
  end

  def find_message
    @message = @room.messages.find_by id: params[:id]
    unless @message
      render json: {message: t("rooms.message_not_found")}, status: 404
    end
  end
  def new_message_params
    params.require(:message).permit :raw_content
  end
end
