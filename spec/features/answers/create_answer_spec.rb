require 'rails_helper'

feature 'Create answer', %q{
  In order to answer the questions
  As an user
  I want to be able to create answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user creates answer with valid attributes', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: 'My answer'
    click_on 'Post your answer'

    expect(page).to have_content 'You answered a question'
    expect(page).to have_content 'My answer'
  end

  scenario 'Authenticated user creates answer with invalid attributes', js: true do
    @answers = create_list(:answer, 2, question: question, user: user)

    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: ''
    click_on 'Post your answer'

    expect(page).to have_content "Body can't be blank"
    expect(page).to have_no_content "No answers yet"
    expect(page).to have_content @answers[0].body
    expect(page).to have_content @answers[1].body
  end

  scenario 'Non-authenticated user try to create answer' do
    visit question_path(question)
    fill_in 'Body', with: 'My answer'
    click_on 'Post your answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
