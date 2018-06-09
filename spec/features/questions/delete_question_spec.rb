require_relative '../features_helper'

feature 'Delete question', %q{
  In order to delete question
  As an authenticated user
  I want to be able to delete question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }


  scenario 'Delete your own question' do
    sign_in(user)
    visit questions_path
    click_on 'Delete'

    expect(page).to have_content 'Question was successfully destroyed.'
    expect(page).to have_no_content question.title
  end

  scenario "Delete another user's question" do
    sign_in(another_user)
    visit questions_path

    expect(page).to_not have_link 'Delete'
  end

  scenario 'Non-authenticated guest try to delete question' do
    visit questions_path

    expect(page).to_not have_link 'Delete'
  end
end
