class CreateUserRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :user_rooms do |t|
      t.references :user, foreign_key: true
      t.references :room, foreign_key: true
      t.integer :last_message, default: 0
      t.boolean :is_admin, default: false
      t.datetime :focus_at
      t.boolean :is_accept, default: false
      t.timestamps
    end
  end
end
