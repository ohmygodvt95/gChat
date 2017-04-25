class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.references :user, foreign_key: true, index: true
      t.references :room, foreign_key: true, index: true
      t.text :content, null: false
      t.datetime :due_date, null: false
      t.timestamps
    end
  end
end
