class Question < ApplicationRecord
  include Ratingable
  include Commentable
  include Subscribable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable

  belongs_to :user

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank
end
