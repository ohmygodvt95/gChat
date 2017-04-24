class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true, index: true
      t.references :room, foreign_key: false
      t.string :content
      t.boolean :is_read, default: false
      t.timestamps
    end
  end
end
