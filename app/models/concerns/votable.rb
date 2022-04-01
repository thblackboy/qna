module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def vote_difference
    votes.sum(:value)
  end
end
