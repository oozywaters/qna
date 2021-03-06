require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for admin' do
    let(:user) { create :admin }

    it { should be_able_to :manage, :all }
  end

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question) { create :question, user: user }
    let(:other_question) { create :question, user: other_user }
    let(:question_attachment) { create :attachment, attachable: question }
    let(:other_question_attachment) { create :attachment, attachable: other_question }
    let(:answer) { create :answer, user: user, question: question }
    let(:other_answer) { create :answer, user: other_user, question: other_question }
    let(:answer_attachment) { create :attachment, attachable: answer }
    let(:other_answer_attachment) { create :attachment, attachable: other_answer }

    it { should_not be_able_to :manage, :all }

    context 'Question' do
      let!(:vote) { create(:rating, ratingable: other_question, user: user) }
      let!(:other_vote) { create(:rating, ratingable: question, user: other_user) }

      it { should be_able_to :create, Question }
      it { should be_able_to :destroy, question, user: user }
      it { should_not be_able_to :destroy, other_question, user: user }
      it { should be_able_to :update, question, user: user }
      it { should_not be_able_to :update, other_question, user: user }
      it { should_not be_able_to [:vote_up, :vote_reset, :vote_down], question, user: user }
      it { should be_able_to [:vote_up, :vote_reset, :vote_down], other_question, user: user }
      it { should be_able_to :destroy, question_attachment, user: user }
      it { should_not be_able_to :destroy, other_question_attachment, user: user }
    end

    context 'Answer' do
      let!(:vote) { create(:rating, ratingable: other_answer, user: user) }
      let!(:other_vote) { create(:rating, ratingable: answer, user: other_user) }

      it { should be_able_to :create, Answer }
      it { should be_able_to :destroy, answer, user: user }
      it { should_not be_able_to :destroy, other_answer, user: user }
      it { should be_able_to :update, answer, user: user }
      it { should_not be_able_to :update, other_answer, user: user }
      it { should_not be_able_to [:vote_up, :vote_reset, :vote_down], answer, user: user }
      it { should be_able_to [:vote_up, :vote_reset, :vote_down], other_answer, user: user }
      it { should be_able_to :destroy, answer_attachment, user: user }
      it { should_not be_able_to :destroy, other_answer_attachment, user: user }
      it { should be_able_to :destroy, answer_attachment, user: user }
      it { should_not be_able_to :destroy, other_answer_attachment, user: user }
      it { should_not be_able_to :select_best, other_answer, user: user }
      it { should be_able_to :select_best, answer, user: user }
    end

    context 'Comment' do
      it { should be_able_to :create, Comment }
    end

    context 'Subscriptions' do
      it { should be_able_to :create, Subscription }
      it { should be_able_to :destroy, Subscription }
    end
  end
end
