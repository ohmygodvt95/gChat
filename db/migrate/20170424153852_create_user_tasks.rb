class CreateUserTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :user_tasks do |t|
      t.references :user, foreign_key: true, index: true
      t.references :task, foreign_key: true, index: true
      t.boolean :is_completed, default: false
      t.timestamps
    end
  end
end
