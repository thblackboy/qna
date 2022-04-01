class AnswersController < ApplicationController
  include Votabled
  before_action :authenticate_user!

  expose(:question)
  expose(:answers) { question.answers }
  expose :answer, build: ->(answer_params) { current_user.answers.build(answer_params) }
  
  def create
    answer.question = question
    answer.save
  end

  def update
    answer.files.attach(params[:answer][:files]) unless params[:answer][:files].nil?
    answer.update(answer_params_for_edit)
  end

  def set_best
    question = answer.question
    if current_user.author_of?(question)
      answer.author.achieves.push(question.achieve) if question.achieve.present?
      @old_best_answer_id = question.best_answer_id
      question.update(best_answer_id: answer.id)
    end
  end

  def destroy
    @question = answer.question
    if current_user.author_of?(answer)
      answer.destroy
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def answer_params_for_edit
    params.require(:answer).permit(:body, links_attributes: [:name, :url])
  end
end
