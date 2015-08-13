class AnswerChoice < ActiveRecord::Base
  validates :answer_choice, presence: true
  validates :question_id, presence: true
end
