class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose(:question)
  expose(:answers) { question.answers }
  expose :answer, build: ->(answer_params) { current_user.answers.build(answer_params) }
  
  def create
    answer.question = question
    answer.save
  end

  def update
    answer.update(answer_params)
  end

  def destroy
    @question = answer.question
    if current_user.author_of?(answer)
      answer.destroy
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
