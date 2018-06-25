require 'rails_helper'

RSpec.describe AnswerNotificationJob, type: :job do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) {create(:answer, question: question, user: user)}
  let!(:users) { create_list(:user, 5) }

  before { question.unsubscribe(user) }

  it 'should send notifications to subscribed users' do
    users.each do |user|
      question.subscribe(user)
      expect(AnswerNotificationMailer).to receive(:notify).with(user, answer).and_call_original
    end

    AnswerNotificationJob.perform_now(answer)
  end

  it 'should not send notifications to unsubscribed users' do
    expect(AnswerNotificationMailer).to_not receive(:notify).with(user, answer).and_call_original
  end
end
