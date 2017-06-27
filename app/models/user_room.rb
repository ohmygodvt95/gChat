class UserRoom < ApplicationRecord
  after_create {InviteBoardcastJob.perform_now self}
  after_update :update_focus_at, if: :focus_at_changed?

  belongs_to :user
  belongs_to :room

  protected
  def update_focus_at
    UserRoomBoardcastJob.perform_now self
  end
end
