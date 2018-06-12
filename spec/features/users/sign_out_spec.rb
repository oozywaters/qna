require_relative "../features_helper"

feature 'log out', %{
  In order to be able simple user
  As a full user
  I want log out
} do

  given(:user) { create(:user) }

  scenario "Log out" do
    sign_in(user)
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end

end
