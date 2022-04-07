class AnswerCommentChannel < ApplicationCable::Channel
  def subscribed
    stream_from "answers_by_question_#{params[:question_id]}"
  end
end