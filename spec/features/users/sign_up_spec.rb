require_relative "../features_helper"

feature 'Sign up', %{
  up order to be able full user
  As a simple user
  I want sign up
} do

  scenario "sign up" do

    visit new_user_registration_path

    fill_in "Email", with: 'user@email.com'
    fill_in "Password", with: "12345678"
    fill_in "Password confirmation", with: "12345678"
    click_button 'Sign up'
    expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'

    open_email('user@email.com')
    current_email.click_link 'Confirm my account'

    expect(page).to have_content('Your email address has been successfully confirmed.')
  end

  scenario "sign up invalid params" do
    visit new_user_registration_path

    fill_in "Email", with: ''
    fill_in "Password", with: ''
    fill_in "Password confirmation", with: ''
    click_button 'Sign up'
    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end
end
