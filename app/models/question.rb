class Question < ActiveRecord::Base
  validates :question, presence: true
  validates :poll_id, presence: true

  belongs_to(
    :poll,
    :class_name => "Poll",
    :foreign_key => :poll_id,
    :primary_key => :id
  )
end
