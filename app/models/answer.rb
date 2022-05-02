class Answer < ApplicationRecord
  include Votable
  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_one :best_for_question, class_name: 'Question', foreign_key: 'best_answer_id', dependent: :nullify
  has_many :links, dependent: :destroy, as: :linkable
  has_many :comments, dependent: :destroy, as: :commentable
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  after_create :send_alarm_to_subscribers

  private
  def send_alarm_to_subscribers
    NewAnswerAlarmJob.perform_later(self)
  end
end
