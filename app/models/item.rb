class Item < ActiveRecord::Base
  has_many :item_records
  has_many :characters, through :item_records
end
