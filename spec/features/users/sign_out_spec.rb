require 'rails_helper'

describe "Logging Out" do
  it "allows a Logged in user to Log out" do
    user = create(:user)
    visit "/login"

    expect(page).to have_content("Log In")
    fill_in "email", with: user.email
    fill_in "password", with: "tremelo1"
    click_button "Log In"

    expect(page).to have_content("Log Out")
    click_link "Log Out"
    expect(page).to_not have_content("Log Out")
    expect(page).to have_content("Log In")
  end
end