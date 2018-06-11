require_relative "../features_helper"

feature 'Sign in', %{
  In order to be able full user
  As a simple user
  I want sign in
} do

  given(:user) { create(:user) }

  scenario "sign in" do
    sign_in(user)
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario "sign in invalid params" do
    visit new_user_session_path
    fill_in "Email", with: 'user@invalid.com'
    fill_in "Password", with: '123456789'
    click_button 'Log in'
    expect(page).to have_content 'Invalid Email or password.'
  end

end
