require_relative "../features_helper"

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given!(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_user) { create(:user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'The user adds more than one file', js: true do
    fill_in 'Body', with: 'My answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_link 'Add attachment'
    within first(".nested-fields") do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Create Answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end
  end

  scenario 'User deletes the file when creating', js: true do
    fill_in 'Body', with: 'My answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_link 'Delete'
    click_on 'Create Answer'
    expect(page).to_not have_link 'spec_helper.rb'
  end

  scenario 'Deleting a file after creation', js: true do
    fill_in 'Body', with: 'Answer text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create Answer'

    within '.answers' do
      click_link 'Remove file'
      page.driver.browser.switch_to.alert.accept
      expect(page).to_not have_link 'spec_helper.rb'
    end
  end

  scenario 'Another user does not see the link delete', js: true do
    within '.new_answer_form' do
      fill_in 'Body', with: 'Answer text'
    end
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create Answer'
    click_on 'Log out'
    sign_in(other_user)
    click_link question.title
    expect(page).to_not have_link 'Remove file'
  end
end
