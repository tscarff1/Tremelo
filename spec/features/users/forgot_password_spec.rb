require 'rails_helper'

describe "Forgotten passswords" do
  let!(:user) { create(:user) }

  it "sends a user an email" do
    visit login_path
    click_link "Forgot Password"
    fill_in "email", with: user.email
    expect {
      click_button "Reset Password"
    }.to change{ ActionMailer::Base.deliveries.size }.by(1)
  end

  it "resets a password when following the email link" do
    visit login_path
    click_link "Forgot Password"
    fill_in "email", with: user.email
    click_button "Reset Password"
    open_email(user.email)
    current_email.click_link "http://"
    expect(page).to have_content("Change Your Password")

    fill_in "Password", with: "mynewpassword1"
    fill_in "Password (again)", with: "mynewpassword1"
    click_button "Change Password"
    expect(page).to have_content("Password updated")
    expect(page.current_path).to eq(root_path)

    click_link "Log Out"
    expect(page).to have_content("You've logged out")
    visit login_path
    fill_in "email", with: user.email
    fill_in "Password", with: "mynewpassword1"
    click_button "Log In"
    expect(page).to have_content("Successfully logged in")
  end
end