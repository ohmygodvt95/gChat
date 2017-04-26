class ChatController < ApplicationController
  before_action :authenticate_user!, only: :index
  layout "chat"

  def index
  end
end
