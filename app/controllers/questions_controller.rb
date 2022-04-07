class QuestionsController < ApplicationController
  include Votabled
  before_action :authenticate_user!, except: %i[index show]
  after_action :publish_question, only: [:create]
  after_action :publish_comment, only: [:add_comment]
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
    gon.question_id = question.id
  end

  def add_comment
    @comment = current_user.comments.new(body: params['body'])
    question.comments.push(@comment)
  end

  def delete_attached_file
    @file = ActiveStorage::Attachment.find(params[:file_id])
    @file.purge if current_user.author_of?(question) && @file.present?
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

  def publish_question
    unless question.errors.any?
      ActionCable.server.broadcast('questions', { html: {
        author: ApplicationController.render(partial: 'templates/questions/question',
                                              locals: { question: question, current_user: current_user }
          ),
        user: ApplicationController.render(partial: 'templates/questions/question',
                                              locals: { question: question, current_user: User.new }
          ),
        guest: ApplicationController.render(partial: 'templates/questions/question',
                                              locals: { question: question, current_user: nil }
          )
        
      }, author_id: current_user.id })
    end
  end

  def publish_comment
    unless @comment.errors.any?
      ActionCable.server.broadcast('question_comments', { html: ApplicationController.render(partial: 'templates/comments/comment',
                                                                                      locals: { comment: @comment }),
                                                  author_id: current_user.id,
                                                  question_id: question.id })
    end
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url id _destroy],
                                                    achieve_attributes: %i[title image])
  end

  def question_params_for_edit
    params.require(:question).permit(:title, :body, links_attributes: %i[name url id _destroy])
  end
end
