class Api::V1::TasksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :find_room, only: [:create, :update, :destroy]
  before_action :find_task, only: [:update, :destroy]

  def index
    if params[:room_id]
      @user_tasks = current_user.tasks.where(room_id: params[:room_id])
        .where("user_tasks.is_completed = ?", false)
    else
      @user_tasks = current_user.tasks.where("user_tasks.is_completed = ?", false)
    end
  end

  def create
    task = @room.tasks.new due_date: params[:task][:due_date],
      content: params[:task][:content], user_id: current_user.id
    task.save!
    params[:task][:list].each do |obj|
      user = @room.users.find_by id: obj[:id]
      task.users.push user
    end
    task.save!
    render json: {message: t("rooms.task_created")}
  end

  def update
    user_task = @task.user_tasks.find_by user_id: current_user.id
    user_task.update_attributes is_completed: true
  end

  protected
  def find_room
    @room = current_user.rooms.find_by id: params[:room_id]
    unless @room
      render json: {message: t("rooms.room_not_found")}, status: 404
    end
  end

  def find_task
    @task = current_user.tasks.find_by id: params[:id]
  end
end
