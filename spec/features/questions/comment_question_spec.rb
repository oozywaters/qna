require_relative "../features_helper"

feature 'Add comment to question', %q{
  To make a comment to the question
  As an authenticated user
  I want to create a comment
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Create comment', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Comment', with: 'Comment text'
    click_on 'Create Comment'
    expect(page).to have_content 'Comment text'
  end

  scenario 'Create comment with invalid attributes', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Comment', with: ''
    click_on 'Create Comment'

    expect(page).to have_content "Body can't be blank"
  end

  context "mulitple sessions" do
    scenario "comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Comment', with: 'Comment text'
        click_on 'Create Comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Comment text'
      end
    end
  end
end
