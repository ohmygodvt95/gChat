class Api::V1::ContactsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, except: [:new, :show, :edit]

  def index
    if params[:act].present?
      @relationship = Relationship.request_contact(current_user.id)
        .page params[:page]
    elsif params[:query]
      params[:user] = current_user
      @users = User.search(params).page params[:page]
    else
      @users = Kaminari.paginate_array(current_user.contacts)
        .page params[:page]
    end
  end

  def create
    if Relationship.exist_contact([params[:contact][:user_receiver_id],
      current_user.id]).present?
      @message = t "contacts.message.contact_already"
    else
      contact = Relationship.new new_contact_params
        .merge user_request_id: current_user.id
      if contact.save
        @message = t "contacts.message.request",
          name: contact.user_receiver.username
      else
        @message = t "contacts.message.request_failure",
          name: contact.user_receiver.username
      end
    end
  end

  def update
    contact = Relationship.find_by user_request_id: params[:id],
      user_receiver_id: current_user.id
    if contact
      if contact.update_attributes is_accept: true
        @message = t "contacts.message.request_accept",
          name: contact.user_request.username
      else
        @message = t "contacts.message.request_accept_failure",
          name: contact.user_request.username
      end
    else
      @message = t "contacts.message.user_not_found"
    end
  end

  def destroy
    relation ||= Relationship
      .find_by user_request_id: current_user.id, user_receiver_id: params[:id]
    relation ||= Relationship
      .find_by user_request_id: params[:id], user_receiver_id: current_user.id
    if relation
      relation.destroy
      @message = t "contacts.message.contact_destroy"
    else
      @message = t "contacts.message.contact_not_found"
    end
    render json: {message: @message}
  end

  protected
  def new_contact_params
    params.require(:contact).permit :user_receiver_id, :user_request_id
  end
end
