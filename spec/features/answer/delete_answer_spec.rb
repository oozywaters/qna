require 'rails_helper'

feature 'Delete answer', %q{
  In order to delete answer
  As an authenticated user
  I want to be able to delete answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Delete my answer' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'Answer was successfully deleted'
    within '.answers' do
      expect(page).to have_no_content answer.body
    end
  end

  scenario "Delete someone else's answer" do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end

  scenario 'Non-authenticated guest tries to delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end
end