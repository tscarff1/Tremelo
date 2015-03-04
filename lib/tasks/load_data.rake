task users: :environment do
  100_000.times do
    User.create(display_name: Faker::App.name,
                    first_name: Faker::Name.first_name,
                    last_name: Faker::Name.last_name,
                    email: Faker::Internet.email,
                    password: "password",
                    password_confirmation: "password",
                    state: Faker::Address.state,
                    city: Faker::Address.city,
                    profile_picture: Faker::Avatar.image)
  end
end

