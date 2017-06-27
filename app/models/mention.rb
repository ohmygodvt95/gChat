class Mention < ApplicationRecord
  after_create {MentionBoardcastJob.perform_now self}
  after_update :update_is_read, if: :is_read_changed?

  belongs_to :user
  belongs_to :room
  belongs_to :message

  has_one :mention_user, class_name: User.name, foreign_key: :mention_user_id

  protected
  def update_is_read
    MentionUpdateBoardcastJob.perform_now self
  end
end
