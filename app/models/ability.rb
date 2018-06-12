class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    user ? user_abilities : guest_abilities
  end

  private

  def guest_abilities
    can :read, [Question, Answer, Comment]
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment]
    can :destroy, [Question, Answer], user_id: user.id
    can :update, [Question, Answer], user_id: user.id

    alias_action :vote_up, :vote_down, :vote_reset, to: :vote
    can :vote, [Question, Answer] do |resource|
      user.non_author_of?(resource)
    end

    can :destroy, Attachment do |attachment|
      user.author_of?(attachment.attachable)
    end

    can :select_best, Answer do |answer|
      user.author_of?(answer.question) && !answer.best?
    end
  end
end
