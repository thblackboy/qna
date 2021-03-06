class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_answer, only: %i[show update destroy]
  before_action :set_question, only: %i[index create]
  authorize_resource
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def show
    render json: @answer, status: 200
  end

  def create
    @answer = current_resource_owner.answers.build(answer_params)
    @answer.question = @question
    if @answer.save
      render json: @answer, status: 201
    else
      head 400
    end
  end

  def index
    render json: @question.answers, each_serializer: AnswersSerializer, status: 200
  end

  def update
    @answer.update(answer_params)
    if @answer.errors.any?
      head 400
    else
      render json: @answer, status: 200
    end
  end

  def destroy
    authorize!(:destroy, @answer)
    @answer.destroy
    head 200
  end

  private
  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, links_attributes: [:name, :url])
  end

  def record_not_found
    head 404
  end
end
