class CreateReplies < ActiveRecord::Migration[5.0]
  def change
    create_table :replies do |t|
      t.references :user, foreign_key: true, index: true
      t.references :room, foreign_key: true, index: true
      t.references :message, foreign_key: true, index: true
      t.references :reply_user, index: true, foreign_key: {to_table: :users}
      t.references :reply_message, index: true, foreign_key: {to_table: :messages}
      t.boolean :is_read, default: false
      t.timestamps
    end
  end
end
