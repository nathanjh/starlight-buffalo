FactoryGirl.define do
  factory :post do
    title { Faker::Hipster.sentence(3) }
    body { Faker::Hacker.say_something_smart }
    association :project
  end
end
