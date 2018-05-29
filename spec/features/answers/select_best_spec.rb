require_relative "../features_helper"

feature 'Select best answer', %q{
  That people know the best answer
  As the author of the question
  I want to choose the best answer
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:best_answer) { create(:answer, question: question, user: user, best: true) }

  scenario 'The author chooses the best answer', js: true do
    sign_in(user)

    visit question_path(question)

    within ".answer_#{answer.id}" do
      click_link "Best"
      expect(page).to_not have_link "Best"
    end
    within ".best_true" do
      expect(page).to have_content(answer.body)
    end
  end

  describe 'The author chooses another better answer', js: true do
    before do
      sign_in(user)
      best_answer
      create_list(:answer, 3, question: question, user: user)
      visit question_path(question)

      within ".answer_#{answer.id}" do
        click_link 'Best'
      end
    end

    scenario 'After selecting a new answer, the old one becomes simple' do
      within ".best_true" do
        expect(page).to_not have_content(best_answer.body)
      end

      within ".answer_#{best_answer.id}" do
        expect(page).to have_link "Best"
      end
    end

    scenario 'After choosing a new best answer, he takes his place' do
      within ".best_true" do
        expect(page).to have_content(best_answer.body)
      end

      within ".answer_#{answer.id}" do
        expect(page).to_not have_link "Best"
      end

      within ".best_true" do
        expect(page).to have_content(answer.body)
      end
    end

  end

  scenario 'Not the author of the question tries to choose the best question' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_link "Best"
  end

  scenario 'Not the auth tries to choose the best question' do
    visit question_path(question)

    expect(page).to_not have_link "Best"
  end
end
