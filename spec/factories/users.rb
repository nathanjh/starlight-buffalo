FactoryGirl.define do
  factory :user do
    # to prevent duplicate usernames
    username { Faker::Internet.user_name + rand(9999).to_s }
    # to prevent duplicate emails
    email { Faker::Internet.free_email + rand(9999).to_s }
    password 'password'
  end
end
