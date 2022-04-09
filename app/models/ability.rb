# frozen_string_literal: true

class Ability
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer]

    can :update, Question, { author_id: user.id }
    can :update, Answer, { author_id: user.id }

    can :destroy, Question, { author_id: user.id }
    can :destroy, Answer, { author_id: user.id }

    can :vote_up, Question
    can :vote_down, Question
    cannot :vote_up, Question, { author_id: user.id }
    cannot :vote_down, Question, { author_id: user.id }

    can :vote_up, Answer
    can :vote_down, Answer
    cannot :vote_up, Answer, { author_id: user.id }
    cannot :vote_down, Answer, { author_id: user.id }

    can :destroy, Vote, { voter_id: user.id }

    can :add_comment, [Question, Answer]

    can :destroy, ActiveStorage::Attachment, { record: { author_id: user.id } }

    can :set_best, Answer, { question: { author_id: user.id } }
  end
end
