module Ratingable
  extend ActiveSupport::Concern

  included do
    has_many :ratings, as: :ratingable, dependent: :destroy
  end

  def vote_up(user)
    ratings.create!(vote: 1, user: user)
  end

  def vote_down(user)
    ratings.create!(vote: -1, user: user)
  end

  def vote_reset(user)
    ratings.where(user: user).delete_all
  end

  def rating
    ratings.sum(:vote)
  end

  def voted_by?(user)
    ratings.exists?(user: user)
  end
end
