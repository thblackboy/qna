class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, foreign_key: 'author_id', dependent: :destroy
  has_many :question_subscribers, foreign_key: 'subscriber_id', dependent: :destroy
  has_many :subscribed_questions, foreign_key: 'question_id', through: :question_subscribers
  has_many :answers, foreign_key: 'author_id', dependent: :destroy
  has_many :comments, foreign_key: 'author_id', dependent: :destroy
  has_many :achieves, class_name: 'Achieve', dependent: :nullify
  has_many :votes, foreign_key: 'voter_id', dependent: :destroy
  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all
  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  scope :all_except, ->(user) { where.not(id: user.id) }

  def vote_to(item)
    votes.find_by(votable: item)
  end

  def subscribed_to?(question)
    subscribed_questions.include?(question)
  end
end
