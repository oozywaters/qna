require_relative "../features_helper"

feature 'Search', %q{
  To find resources
  As a guest user
  I want to perform search
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:answer_comment) { create(:comment, user: user, commentable: question) }
  given!(:question_comment) { create(:comment, user: user, commentable: answer) }

  scenario "A general search is made (category all)", js: true do
    ThinkingSphinx::Test.run do
      visit search_index_path
      click_button 'Search'
      expect(page).to have_link question.title
      expect(page).to have_link answer.body
      expect(page).to have_link answer_comment.body
      expect(page).to have_link question_comment.body
      expect(page).to have_content user.email
    end
  end

  scenario "Not found any resource", js: true do
    ThinkingSphinx::Test.run do
      visit search_index_path
      fill_in "query", with: 'Not found'
      click_button 'Search'
      expect(page).to have_content "No results found for Not found."
    end
  end

  scenario "A general search", js: true do
    ThinkingSphinx::Test.run do
      visit search_index_path
      fill_in "query", with: question.title
      click_button 'Search'
      expect(page).to have_link question.title
      expect(page).to_not have_link answer.body
      expect(page).to_not have_link answer_comment.body
      expect(page).to_not have_link question_comment.body
      expect(page).to_not have_content user.email
    end
  end

  scenario "Category question", js: true do
    ThinkingSphinx::Test.run do
      visit search_index_path
      select "Questions", from: "category"
      click_button 'Search'
      expect(page).to have_link question.title
      expect(page).to_not have_link answer.body
      expect(page).to_not have_link answer_comment.body
      expect(page).to_not have_link question_comment.body
      expect(page).to_not have_content user.email
    end
  end

  scenario "Category answer", js: true do
    ThinkingSphinx::Test.run do
      visit search_index_path
      select "Answers", from: "category"
      click_button 'Search'
      expect(page).to_not have_link question.title
      expect(page).to have_link answer.body
      expect(page).to_not have_link answer_comment.body
      expect(page).to_not have_link question_comment.body
      expect(page).to_not have_content user.email
    end
  end

  scenario "Category comment", js: true do
    ThinkingSphinx::Test.run do
      visit search_index_path
      select "Comments", from: "category"
      click_button 'Search'
      expect(page).to_not have_link question.title
      expect(page).to_not have_link answer.body
      expect(page).to have_link answer_comment.body
      expect(page).to have_link question_comment.body
      expect(page).to_not have_content user.email
    end
  end

  scenario "Category user", js: true do
    ThinkingSphinx::Test.run do
      visit search_index_path
      select "Users", from: "category"
      click_button 'Search'
      expect(page).to_not have_link question.title
      expect(page).to_not have_link answer.body
      expect(page).to_not have_link answer_comment.body
      expect(page).to_not have_link question_comment.body
      expect(page).to have_content user.email
    end
  end
end