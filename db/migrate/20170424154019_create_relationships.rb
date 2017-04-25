class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |t|
      t.references :user_request, index: true, foreign_key: {to_table: :users}
      t.references :user_receiver, index: true, foreign_key: {to_table: :users}
      t.boolean :is_accept, default: false
      t.timestamps
    end
  end
end
