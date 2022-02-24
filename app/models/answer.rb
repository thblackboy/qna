class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_one :best_for_question, class_name: 'Question', foreign_key: 'best_answer_id', dependent: :nullify

  validates :body, presence: true
end
