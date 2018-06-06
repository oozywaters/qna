class Answer < ApplicationRecord
  include Ratingable

  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable

  validates :body, presence: true

  scope :by_best, -> { order(best: :desc, created_at: :desc) }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  def select_best
    old_best = question.answers.find_by(best: true)

    transaction do
      old_best.update!(best: false) if old_best
      update!(best: true)
    end
  end
end
