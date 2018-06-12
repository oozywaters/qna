require_relative '../features_helper'
feature 'User sign up', %q{
  Is order to be able to sign in
  As a guest user
  I want to be able to sign up
} do

  scenario 'Guest user tries to sign up' do
    visit new_user_registration_path

    fill_in "Email", with: 'yetanotheruser@email.com'
    fill_in "Password", with: "12345678"
    fill_in "Password confirmation", with: "12345678"
    click_button 'Sign up'
    expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
  end
end
