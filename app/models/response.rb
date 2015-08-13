class Response < ActiveRecord::Base
  validates :answer_choice_id, presence: true
  validates :respondent_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :respondent_is_not_poll_author

  belongs_to(
    :respondent,
    :class_name => "User",
    :foreign_key => :respondent_id,
    :primary_key => :id
  )

  belongs_to(
    :answer_choice,
    :class_name => "AnswerChoice",
    :foreign_key => :answer_choice_id,
    :primary_key => :id
  )

  has_one(
    :question,
    :through => :answer_choice,
    :source => :question
  )

  def sibling_responses
    #all_responses = self.question.responses
    if self.id.nil?
      self.question.responses
    else
      self.question.responses.where("responses.id != ?", self.id)
    end
  end

  def respondent_has_not_already_answered_question
    if sibling_responses.exists?(["responses.respondent_id = ?", self.respondent_id])
      errors[:response_exists] << "user has already responded"
    end
  end

  def respondent_is_not_poll_author
    if self.answer_choice.question.poll.author_id == respondent_id
      errors[:poll_author] << "user is author of poll!"
    end
  end

end
