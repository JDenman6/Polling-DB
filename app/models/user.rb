class User < ActiveRecord::Base
  validates :user_name, uniqueness: true, presence: true
end
