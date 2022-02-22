class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose(:question)
  expose(:answers) { question.answers }
  expose :answer, build: ->(answer_params) { current_user.answers.build(answer_params) }
  def create
    answer.question = question
    if answer.save
      redirect_to question, notice: 'Answer was created'
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      redirect_to question, notice: 'Answer was deleted'
    else
      redirect_to question, notice: "You can't delete someone else's answer"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
