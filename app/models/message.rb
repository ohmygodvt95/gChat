class Message < ApplicationRecord
  after_create :content_progress_after_create
  after_commit {MessageCreatedBoardcastJob.perform_now self}

  belongs_to :room
  belongs_to :user

  has_many :replies, dependent: :destroy
  has_many :mentions, dependent: :destroy

  scope :order_by_id_desc, ->{order(id: :desc).limit Settings.msg_limit}
  scope :from_by_id, ->(id){where("id < ?", id).order(id: :desc)
    .limit Settings.msg_limit}

  protected
  def content_progress_after_create
    self.content = self.raw_content.gsub "\n", "<br>"
    replies = self.raw_content.scan(/@reply:(\d+)/).map!{|s| s[0].to_i}
    replies.each do |message_id|
      message = Message.find_by id: message_id
      if message
        reply = Reply.create message_id: self.id, room_id: self.room_id,
          reply_user_id: message.user.id, reply_message_id: message.id,
          user_id: self.user_id
        puts "@reply:#{message.id}"
        self.content = self.content.gsub "@reply:#{message.id}",
          "<span data=\"#{message.id}\" class=\"reply\">
          <img src=\"#{message.user.avatar.thumb.url}\"/> RE</span>"
      end
    end
    self.save
  end
end
