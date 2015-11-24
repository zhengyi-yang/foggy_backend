class ChangeDetailsForTree < ActiveRecord::Migration
  def change
    change_table :trees do |t|
      t.remove :avatar_url
      t.rename :namee, :name
      t.integer :level, default: 0
    end
  end
end
