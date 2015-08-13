class User < ActiveRecord::Base
  validates :user_name, uniqueness: true, presence: true

  has_many(
    :authored_polls,
    :class_name => "Poll",
    :foreign_key => :author_id,
    :primary_key => :id
  )

  has_many(
    :responses,
    :class_name => "Response",
    :foreign_key => :respondent_id,
    :primary_key => :id
  )

  def completed_polls
    complete_polls = Poll.joins(:questions => :answer_choices)
      .joins(own_responses)
      .group("polls.id")
      .having("COUNT(DISTINCT questions.id) <= COUNT(own_responses.*)")
      .select("polls.*")

    complete_polls.map do |poll|
      poll.title
    end


    #
    #
    # SELECT
    #   all_polls.*
    # FROM
    #   polls AS all_polls
    # INNER JOIN
    #   questions AS all_questions ON all_polls.id = all_questions.poll_id
    # INNER JOIN
    #   answer_choices AS answers_to_questions ON answers_to_questions.question_id = all_questions.id
    # LEFT OUTER JOIN
    #   (SELECT
    #     responses.*
    #   FROM
    #     responses
    #   WHERE
    #     responses.respondent_id = ?
    #   ) AS own_responses ON answers_to_questions.id = own_responses.answer_choice_id
    # GROUP BY
    #   all_polls.id
    # HAVING
    #   COUNT(DISTINCT all_questions.id) <= COUNT(own_responses.*)
    # ;

  end

  def uncompleted_polls
    uncomplete_polls = Poll.joins(:questions => :answer_choices)
      .joins(own_responses)
      .group("polls.id")
      .having("COUNT(own_responses.*)
          BETWEEN 1 AND (COUNT(DISTINCT questions.id) - 1)")
      .select("polls.*")

    uncomplete_polls.map do |poll|
      poll.title
    end
  end

  def own_responses
    <<-SQL
    LEFT OUTER JOIN (
      SELECT
        responses.*
      FROM
        responses
      WHERE
        responses.respondent_id = #{self.id}
      ) AS own_responses ON answer_choices.id = own_responses.answer_choice_id
    SQL
  end

end
