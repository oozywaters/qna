require_relative '../features_helper'

feature 'Create question', %q{
  In order to ask a question to community
  As an authenticated user
  I want to be able to create questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'test question'
    fill_in 'Body', with: 'text'
    click_on 'Create Question'

    expect(page).to have_content 'Your question was successfully created.'
  end

  scenario 'Non-authenticated user try to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end