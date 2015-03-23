FactoryGirl.define do
  factory :message do
    user_to 1
user_from 1
content "MyText"
  end

end
