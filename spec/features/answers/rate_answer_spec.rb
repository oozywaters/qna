require_relative "../features_helper"

feature 'Rate answer', %q{
  In order to to view the rating of the answer
  As an authenticated user
  I want to vote for the answer
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: other_user) }
  given!(:answer) { create(:answer, user: other_user, question: question) }

  before do
    sign_in(user)
  end

  scenario 'user votes for the positive side of the answer', js: true do
    visit question_path(question)
    within '.answers' do
      click_on '+1'
      expect(page).to_not have_link '-1'
      expect(page).to_not have_link '+1'
      expect(page).to have_link 'Reset'
      expect(page).to have_content 'rating1'
    end
  end

  scenario 'the user votes for the negative side of the answer', js: true do
    visit question_path(question)
    within ".answers" do
      click_link '-1'
      expect(page).to_not have_link '-1'
      expect(page).to_not have_link '+1'
      expect(page).to have_link 'Reset'
      expect(page).to have_content 'rating-1'
    end
  end

  scenario 'User cancels your vote', js: true do
    visit question_path(question)
    within ".answers" do
      click_link '-1'
      expect(page).to have_content 'rating-1'
      expect(page).to have_link 'Reset'
      click_link 'Reset'
      expect(page).to have_content 'rating0'
    end
  end
end
