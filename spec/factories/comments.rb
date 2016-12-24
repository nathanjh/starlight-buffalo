FactoryGirl.define do
  factory :comment do
    body { Faker::ChuckNorris.fact }
    association :user
  end
end
