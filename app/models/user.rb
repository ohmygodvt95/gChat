class User < ApplicationRecord

  has_many :user_rooms, dependent: :destroy
  has_many :user_tasks, dependent: :destroy
  has_many :rooms, through: :user_rooms, dependent: :destroy
  has_many :my_created_rooms, class_name: Room.name, dependent: :destroy
  has_many :mentions, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_many :has_been_mentions, class_name: Mention.name,
    foreign_key: :mention_user_id
  has_many :has_been_replies, class_name: Reply.name,
    foreign_key: :reply_user_id
  has_many :tasks, through: :user_tasks, dependent: :destroy
  has_many :my_created_tasks, class_name: Task.name, dependent: :destroy

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  scope :search, ->(data){where("email like ?", "%#{data[:query]}%")
    .where("id != ?", data[:user].id).where
    .not id: data[:user].contacts(data[:user].id, [true, false]).map(&:id)}

  scope :user_for_private_room,
    ->(user_id){where.not(id: user_id).first}

  def contacts uid = self.id, accept = true
    contacts = Relationship
      .where(user_request_id: uid)
      .or(Relationship.where user_receiver_id: uid)
      .where(is_accept: accept)
    users = []
    contacts.each do |contact|
      if contact.user_request_id == self.id
        users << contact.user_receiver
      else
        users << contact.user_request
      end
    end
    users
  end
end
