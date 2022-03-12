class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, -> { Question.all }
  expose :question, find: ->(id) { Question.with_attached_files.find(id) },
                    build: ->(question_params) { current_user.questions.build(question_params) }

  def create
    if question.save
      redirect_to question, notice: 'Question created'
    else
      render :new
    end
  end

  def new
    question.links.build
    question.achieve = Achieve.new
  end

  def show
    @exposed_answer = Answer.new
    @exposed_answer.links.new
  end

  def delete_attached_file
    @file = ActiveStorage::Attachment.find(params[:file_id])
    if current_user.author_of?(question) && @file.present?
      @file.purge
    end
  end

  def update
    question.files.attach(params[:question][:files]) unless params[:question][:files].nil?
    question.update(question_params_for_edit)
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
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url, :id, :_destroy], achieve_attributes: [:title, :image])
  end

  def question_params_for_edit
    params.require(:question).permit(:title, :body, links_attributes: [:name, :url, :id, :_destroy])
  end

end
