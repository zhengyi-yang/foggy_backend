class Tree < ActiveRecord::Base
  belong_to :user
  validate_presence_of :name, :user_id
end
