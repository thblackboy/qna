class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, foreign_key: 'author_id', dependent: :destroy
  has_many :answers, foreign_key: 'author_id', dependent: :destroy
  has_many :achieves, class_name: 'Achieve', dependent: :nullify
  has_many :votes, foreign_key: 'voter_id', dependent: :destroy

  def vote_to(item)
    votes.find_by(votable: item)
  end

  def author_of?(item)
    id == item.author_id
  end
end
