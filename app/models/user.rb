class User < ActiveRecord::Base
  has_many :charachets
  before_create :set_authentication_token
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  has_and_belongs_to_many :friends,
    class_name: "User",
    join_table: "friendships",
    foreign_key: "user_id",
    association_foreign_key: "friend_user_id"
  has_secure_password

  private
    def set_authentication_token
      return if authentication_token.present?
      self.authentication_token = generate_authentication_token  
    end

    def generate_authentication_token
      loop do
        token = SecureRandom.hex(64)
        break token unless self.class.exists?(authentication_token: token)
      end
    end
end
