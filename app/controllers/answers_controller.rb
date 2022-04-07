class AnswersController < ApplicationController
  include Votabled
  before_action :authenticate_user!
  after_action :publish_answer, only: [:create]
  after_action :publish_comment, only: [:add_comment]


  expose(:question)
  expose(:answers) { question.answers }
  expose :answer, build: ->(answer_params) { current_user.answers.build(answer_params) }
  
  def create
    answer.question = question
    answer.save
  end

  def add_comment
    @comment = current_user.comments.new(body: params['body'])
    answer.comments.push(@comment)
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

  def publish_answer
    unless answer.errors.any?
      AnswerChannel.broadcast_to(question , { html: {
        question_author: ApplicationController.render(partial: 'templates/answers/answer',
                                              locals: { answer: answer, current_user: question.author }
          ),
        user: ApplicationController.render(partial: 'templates/answers/answer',
                                              locals: { answer: answer, current_user: User.new }
          ),
        guest: ApplicationController.render(partial: 'templates/answers/answer',
                                              locals: { answer: answer, current_user: nil }
          )
        
      }, question_author_id: question.author_id, author_id: current_user.id })
    end
  end

  def publish_comment
    unless @comment.errors.any?
      ActionCable.server.broadcast("answers_by_question_#{answer.question.id}", { html: ApplicationController.render(partial: 'templates/comments/comment',
                                                                                      locals: { comment: @comment }),
                                                  author_id: current_user.id,
                                                  answer_id: answer.id })
    end
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def answer_params_for_edit
    params.require(:answer).permit(:body, links_attributes: [:name, :url])
  end
end
