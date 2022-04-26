class QuestionSubscribersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question
  
  def subscribe
    authorize!(:subscribe, Question)
    current_user.subscribed_questions.push(@question)
  end

  def unsubscribe
    authorize!(:unsubscribe, Question)
    current_user.subscribed_questions.delete(@question) if current_user.subscribed_questions.include?(@question)
  end

  private
  def set_question
    @question = Question.find(params[:question_id])
  end
end
