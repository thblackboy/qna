class QuestionCommentChannel < ApplicationCable::Channel
  def subscribed
    stream_from "question_comments"
  end
end