class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :by_best, -> { order(best: :desc, created_at: :desc) }

  def select_best
    old_best = question.answers.find_by(best: true)

    transaction do
      old_best.update!(best: false) if old_best
      update!(best: true)
    end
  end
end
