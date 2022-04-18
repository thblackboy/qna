class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[show update destroy]

  authorize_resource

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def create
    @question = current_resource_owner.questions.build(question_params)
    if @question.save
      render json: @question, status: 201
    else
      head 400
    end
  end

  def update
    @question.update(question_params)
    if @question.errors.any?
      head 400
    else
      render json: @question, status: 200
    end
  end

  def show
    render json: @question
  end

  def destroy
    authorize!(:destroy, @question)
    @question.destroy
    head 200
  end

  private
  def set_question
    @question = Question.find(params[:id])
  end

  def record_not_found
    head 404
  end

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: %i[name url id _destroy],
                                                    achieve_attributes: %i[title image])
  end
end
