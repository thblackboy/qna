module Votabled
  extend ActiveSupport::Concern
  included do
    authorize_resource    
    before_action :set_votable, only: %i[vote_up vote_down]
  end

  def vote_up
    unless current_user.vote_to(@votable).present?
      @votable.votes.push(current_user.votes.new(value: 1))
    end
    render json: { id: @votable.id, total: @votable.vote_difference, vote_destroy_path: vote_path(current_user.vote_to(@votable)) }
  end

  def vote_down
    unless current_user.vote_to(@votable).present?
      @votable.votes.push(current_user.votes.new(value: -1))
    end
    render json: { id: @votable.id, total: @votable.vote_difference, vote_destroy_path: vote_path(current_user.vote_to(@votable)) }
  end

  private

  def set_votable
    @votable = votable_name.classify.constantize.find(params[:id])
  end

  def votable_name
    params[:votable]
  end
end
