class QuestionSubscriber < ApplicationRecord
  belongs_to :subscribed_question, class_name: 'Question', foreign_key: 'question_id'
  belongs_to :subscriber, class_name: 'User', foreign_key: 'subscriber_id'
end
