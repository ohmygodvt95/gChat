class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.references :user, foreign_key: true, index: true
      t.references :room, foreign_key: true, index: true
      t.string :message_type, default: :text
      t.text :raw_content
      t.text :content
      t.timestamps
    end
  end
end
