class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.integer :user_id
      t.string :namee
      t.string :avatar_url
      t.integer :health, default: 100
      t.integer :awareness, default: 0

      t.timestamps null: false
    end
  end
end
