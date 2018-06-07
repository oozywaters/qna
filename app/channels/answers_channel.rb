class AnswersChannel < ApplicationCable::Channel
  def follow(params)
    stream_from "answers_for_question_#{params['id']}"
  end
end
