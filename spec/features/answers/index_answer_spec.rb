require 'rails_helper'

feature 'Show question answers', %q{
  In order to list answers
  As a user
  I want to be able see answers of question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Show question answers to user' do
    @answers = create_list(:answer, 2, question: question, user: user)

    visit question_path(question)
    expect(page).to have_content @answers[0].body
    expect(page).to have_content @answers[1].body
  end
end
