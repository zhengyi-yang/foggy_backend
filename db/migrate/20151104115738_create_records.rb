class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.datetime :record_time
      t.integer :health
      t.belongs_to :character, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
