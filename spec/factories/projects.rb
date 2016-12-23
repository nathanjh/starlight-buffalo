FactoryGirl.define do
  factory :project do
    title { Faker::Book.title }
    description { Faker::ChuckNorris.fact }
    association :user
  end
end
