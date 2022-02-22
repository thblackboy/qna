class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, -> { Question.all }
  expose :question, build: ->(question_params) { current_user.questions.build(question_params) }

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

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: 'Question was deleted'
    else
      redirect_to questions_path, notice: "You can't delete someone else's answer"
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
