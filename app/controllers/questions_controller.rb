class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, -> { Question.all }
  expose :question
  
  def create
    if question.save
      redirect_to question, notice: 'Question created'
    else
      render :new
    end
  end

  def show
    @exposed_answer = Answer.new
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
