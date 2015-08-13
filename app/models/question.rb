class Question < ActiveRecord::Base
  validates :question, presence: true
  validates :poll_id, presence: true

  belongs_to(
    :poll,
    :class_name => "Poll",
    :foreign_key => :poll_id,
    :primary_key => :id
  )

  has_many(
    :answer_choices,
    :class_name => "AnswerChoice",
    :foreign_key => :question_id,
    :primary_key => :id
  )

  has_many(
    :responses,
    :through => :answer_choices,
    :source => :responses
  )

  def results
    ####The bad way
    # choices = self.answer_choices
    # choice_count = {}
    #
    # choices.each do |choice|
    #   choice_count[choice.answer_choice] = choice.responses.count
    # end
    #
    # choice_count

    ####Better way
    # choices =  self.answer_choices.includes(:responses)
    # choice_count = {}
    #
    # choices.each do |choice|
    #   choice_count[choice.answer_choice] = choice.responses.length
    # end
    # choice_count

    #####Best way
    answer_choices = self.answer_choices
      .joins("LEFT OUTER JOIN
        responses ON answer_choices.id = responses.answer_choice_id")
      .where("answer_choices.question_id = ?", self.id)
      .group("answer_choices.id")
      .select("answer_choices.*, COUNT(responses.id) AS response_count")

    answer_choices.map do |choice|
      [choice.answer_choice, choice.response_count]
    end

    # SELECT
    #   answer_choices.*, COUNT(responses.id)
    # FROM
    #   answer_choices
    # LEFT OUTER JOIN
    #   responses ON answer_choices.id = responses.answer_choice_id
    # WHERE
    #   answer_choices.question_id = ?
    # GROUP BY
    #   answer_choices.id


  end

end
