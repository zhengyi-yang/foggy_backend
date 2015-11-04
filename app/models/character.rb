class Character < ActiveRecord::Base
  belong_to :user
  has_many  :records
  has_many :item_records
  has_many :users, through :item_records
  validate_presence_of :name, :user_id
end
