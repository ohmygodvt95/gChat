class UserRoom < ApplicationRecord
  after_create {InviteBoardcastJob.perform_now self}

  belongs_to :user
  belongs_to :room
end
