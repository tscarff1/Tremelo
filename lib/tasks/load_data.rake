task users: :environment do
  1_000.times do
    User.create(display_name: Faker::App.name,
                    first_name: Faker::Name.first_name,
                    last_name: Faker::Name.last_name,
                    email: Faker::Internet.email,
                    password: "password",
                    password_confirmation: "password",
                    state: Faker::Address.state,
                    city: Faker::Address.city,
                    about_me: Faker::Lorem.sentence,
                    profile_picture: Faker::Avatar.image)

  end
end

task bands: :environment do
  50.times do
    location = "#{Faker::Address.city}, #{Faker::Address.state_abbr}"
    Band.create(name: Faker::App.name,
                    location: location,
                    about_me: Faker::Lorem.paragraph,
                    profile_picture: Faker::Avatar.image)
  end

  10.times do
    location = "#{Faker::Address.city}, #{Faker::Address.state_abbr}"
    Band.create(name: Faker::Team.creature,
                    location: location,
                    about_me: Faker::Lorem.paragraph,
                    profile_picture: Faker::Avatar.image)
  end

end

#generate random user_id
    #generate random band_id
    #UserBand.create(user_id: user_id, band_id: band_id)
