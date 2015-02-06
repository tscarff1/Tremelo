require 'rails_helper'

describe "Logging In" do
  it "logs the user in and goes to the profile page" do
    User.create(display_name: "PabloSanchez", first_name: "Sean", last_name: "Winner", email: "sean@tremelo.com", password: "password1", password_confirmation: "password1")
    visit "/"
    click_link "Sign In"
    fill_in "Email Address", with: "sean@tremelo.com"
    fill_in "Password", with: "password1"
    click_button "Log In"
    
    expect(page).to have_content("Todo Lists")
    expect(page).to have_content("Thanks for logging in!")
  end

  it "diplays the email address in the event of a failed login" do
    visit new_user_session_path
    fill_in "Email Address", with: "sean@tremelo.com"
    fill_in "Password", with: "incorrect"
    click_button "Log In"

    expect(page).to have_content("Please check your email and password")
    expect(page).to have_field("Email Address", with: "sean@tremelo.com")
  end
end