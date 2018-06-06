require_relative "../features_helper"

feature 'Question editing', %q{
  To solve your problem
  As an authorized user
  I want to fix my question
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end


  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit questions_path
    end

    scenario 'sees link to Edit' do
      expect(page).to have_link 'Edit'
    end

    scenario 'try to edit his question', js: true do
      within ".question_#{question.id}" do
        click_on 'Edit'
        fill_in 'Title', with: 'edited question title'
        fill_in 'Body', with: 'edited question body'
        click_on 'Save'

        expect(page).to have_content 'edited question title'
        expect(page).to have_content 'edited question body'
      end
    end
  end

  scenario "try to edit other user's question" do
    sign_in(other_user)
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end
end
