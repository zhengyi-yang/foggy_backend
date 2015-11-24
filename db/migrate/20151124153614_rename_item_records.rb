class RenameItemRecords < ActiveRecord::Migration
  def change
    rename_table :item_records, :inventory_items
    change_table :inventory_items do |t|
      t.rename :character_id, :user_id
    end
  end
end
