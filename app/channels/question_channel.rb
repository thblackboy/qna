class QuestionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "questions"
  end
end
