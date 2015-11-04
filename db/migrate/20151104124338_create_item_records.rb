class CreateItemRecords < ActiveRecord::Migration
  def change
    create_table :item_records do |t|
      t.belongs_to :character, index: true, foreign_key: true
      t.belongs_to :item, index: true, foreign_key: true
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
