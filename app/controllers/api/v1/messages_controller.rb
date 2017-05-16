class Api::V1::MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :find_room, except: [:new, :edit]

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

  protected
  def find_room
    @room = current_user.rooms.find_by id: params[:room_id]
    unless @room
      render json: {message: t("rooms.room_not_found")}, status: 404
    end
  end

  def new_message_params
    params.require(:message).permit :raw_content
  end
end
