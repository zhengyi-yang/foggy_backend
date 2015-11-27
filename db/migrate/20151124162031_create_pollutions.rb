class CreatePollutions < ActiveRecord::Migration
  def change
    create_table :pollutions do |t|
      t.string :site_code, :unique => true
      t.float :latitude
      t.float :longitude
      t.integer :index

      t.timestamps null: false
    end
  end
end
