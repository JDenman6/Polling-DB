class Response < ActiveRecord::Base
  validates :answer_choice_id, presence: true
  validates :respondent_id, presence: true

  belongs_to(
    :respondent,
    :class_name => "User",
    :foreign_key => :respondent_id,
    :primary_key => :id
  )
end
