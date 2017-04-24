class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :avatar, null: true
      t.string :organization, null: true
      t.string :division, null: true
      t.string :title, null: true
      t.string :phone, null: true
      t.string :url, null: true
      t.text :description, null: true
      t.boolean :is_online, default: false
      t.timestamps
    end
  end
end
