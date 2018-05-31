require_relative "../features_helper"

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
  end

  scenario 'The user adds more than one file', js: true do
    click_link 'Add attachment'
    within first(".nested-fields") do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb'
  end

  scenario 'User deletes the file when creating', js: true do
    click_link 'Delete'
    click_on 'Create'
    expect(page).to_not have_link 'spec_helper.rb'
  end

  scenario 'Deleting a file after creation', js: true do
    click_on 'Create'
    click_link 'Remove file'
    page.driver.browser.switch_to.alert.accept
    expect(page).to_not have_link 'spec_helper.rb'
  end

  scenario 'Another user does not see the link delete', js: true do
    click_on 'Create'
    click_on 'Log out'
    sign_in(other_user)
    click_link Question.last.title
    expect(page).to_not have_link 'Remove file'
  end
end
