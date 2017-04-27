class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name, null: true
      t.string :avatar, null: true
      t.string :room_type, default: :private
      t.text :description, null: true
      t.timestamps
    end
  end
end
