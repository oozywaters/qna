require_relative '../features_helper'

feature 'Show questions list', %q{
  In order to answer the questions
  As a user
  I want to be able to see all questions
} do

  given(:user) { create(:user) }

  scenario 'User sees all questions' do
    questions = create_list(:question, 2, user: user)
    visit questions_path

    expect(page).to have_content 'All questions'
    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
  end
end
