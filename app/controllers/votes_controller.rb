class VotesController < ApplicationController
  expose :votes, -> { Vote.all }
  expose :vote

  def destroy
    authorize!(:destroy, vote)
    vote.destroy
    votable = vote.votable
    render json: { id: votable.id, total: votable.vote_difference, votable_url: url_for(votable) }
  end
end
