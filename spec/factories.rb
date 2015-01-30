FactoryGirl.define do
  factory :user do
    display_name "display_name"
    first_name  "First"
    last_name   "Last"
    sequence(:email) { |n| "user#{n}@odot.com" }
    password    "tremelo1"
    password_confirmation "tremelo1"
  end

end