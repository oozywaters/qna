require_relative "../features_helper"

feature 'Authorization from providers', %{
  In order to work with Questions and Answers
  As a user
  I want to registration using my other social network accounts
} do


  let(:user) { create(:user, email: 'email@temp.email') }
  let(:email) { 'new@email.com' }

  describe 'Twitter' do
    scenario 'User is authorized for the first time', js: true do
      visit new_user_session_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Add Email'

      fill_in 'Email', with: email
      click_on 'Continue'

      open_email(email)
      current_email.click_link 'Confirm my account'

      expect(page).to have_content('Your email address has been successfully confirmed.')
    end

    scenario 'User is already authorized', js: true do
      auth = mock_auth_hash(:twitter, user.email)
      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content('Successfully authenticated from Twitter account.')
    end

    scenario 'The user typed an email but did not confirm', js: true do
      visit new_user_session_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Add Email'

      fill_in 'Email', with: email
      click_on 'Continue'

      visit root_path

      expect(page).to have_content 'Add Email'
    end
  end

  describe 'Vkontakte' do
    scenario 'User is authorized for the first time', js: true do
      visit new_user_session_path
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Add Email'

      fill_in 'Email', with: email
      click_on 'Continue'

      open_email(email)
      current_email.click_link 'Confirm my account'

      expect(page).to have_content('Your email address has been successfully confirmed.')
    end

    scenario 'User is already authorized', js: true do
      auth = mock_auth_hash(:vkontakte, user.email)
      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content('Successfully authenticated from Vkontakte account.')
    end

    scenario 'The user typed an email but did not confirm', js: true do
      visit new_user_session_path
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Add Email'

      fill_in 'Email', with: email
      click_on 'Continue'

      visit root_path

      expect(page).to have_content 'Add Email'
    end
  end
end
