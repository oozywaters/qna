require_relative "../features_helper"

feature 'subscribe to a question', %q{
  To receive notifications of new replies
  As an authenticated user
  I want to subscribe to a question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_question) { create(:question, user: create(:user)) }

  before do
    sign_in(user)
  end

  scenario 'User can subscribe to a question' do
    visit question_path(other_question)
    click_on 'Subscribe'
    expect(page).to have_content 'You have successfully subscribed'
    expect(page).to_not have_link 'Subscribe'
    expect(page).to have_link 'Unsubscribe'
  end

  scenario 'User can unsubscribe from question' do
    visit question_path(other_question)
    click_on 'Subscribe'
    click_on 'Unsubscribe'
    expect(page).to have_content 'You successfully unsubscribed'
    expect(page).to_not have_link 'Unubscribe'
    expect(page).to have_link 'Subscribe'
  end

  scenario 'User can unsubscribe from his question' do
    visit question_path(question)
    click_on 'Unsubscribe'
    expect(page).to have_content 'You successfully unsubscribed'
    expect(page).to_not have_link 'Unubscribe'
    expect(page).to have_link 'Subscribe'
  end
end
