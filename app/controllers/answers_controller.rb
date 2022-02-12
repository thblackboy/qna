class AnswersController < ApplicationController
  expose(:question)
  expose(:answers) { question.answers }
  expose :answer, build: -> { question.answers.build(answer_params) }
  def create
    if answer.save
      redirect_to question
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
