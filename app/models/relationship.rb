class Relationship < ApplicationRecord
  belongs_to :user_request, class_name: User.name,
    foreign_key: :user_request_id
  belongs_to :user_receiver, class_name: User.name,
    foreign_key: :user_receiver_id
end
