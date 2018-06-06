class CommentsChannel < ApplicationCable::Channel
  def follow(params)
    stream_from "comments_for_question_#{params['id']}"
  end
end
