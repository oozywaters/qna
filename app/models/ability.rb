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

  private

  def admin_abilities
    can :manage, :all
  end

  def guest_abilities
    can :read, [Question, Answer, Comment]
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment, Subscription]
    can :destroy, [Question, Answer], user_id: user.id
    can :update, [Question, Answer], user_id: user.id
    can [:read, :me], [User]

    alias_action :vote_up, :vote_down, to: :vote

    can :vote, [Question, Answer] do |resource|
      user.not_author_of?(resource)
    end

    can :vote_reset, [Question, Answer] do |resource|
      resource.voted_by?(user)
    end

    can :destroy, Attachment do |attachment|
      user.author_of?(attachment.attachable)
    end

    can :select_best, Answer do |answer|
      user.author_of?(answer.question)
    end

    can :destroy, Subscription do |subscription|
      subscription.question.subscribed?(user)
    end
  end
end
