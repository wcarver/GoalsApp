class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.integer :user_id, null: false
      t.text :body, null: false
      t.timestamps null: false
    end
  end
end
