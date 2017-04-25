class CreateMentions < ActiveRecord::Migration[5.0]
  def change
    create_table :mentions do |t|
      t.references :user, foreign_key: true, index: true
      t.references :room, foreign_key: true, index: true
      t.references :message, index: true, foreign_key: {to_table: :messages}
      t.references :mention_user, index: true, foreign_key: {to_table: :users}
      t.boolean :is_read, default: false
      t.timestamps
    end
  end
end
