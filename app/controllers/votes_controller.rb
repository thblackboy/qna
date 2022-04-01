class VotesController < ApplicationController
  expose :votes, -> { Vote.all }
  expose :vote

  def destroy
    vote.destroy if vote.voter_id == current_user.id
    votable = vote.votable
    render json: { id: votable.id, total: votable.vote_difference }
  end
end
