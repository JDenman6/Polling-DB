class Question < ActiveRecord::Base
  validates :question, presence: true
  validates :poll_id, presence: true
end
