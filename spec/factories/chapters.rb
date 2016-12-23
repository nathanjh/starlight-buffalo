FactoryGirl.define do
  factory :chapter do
    title { Faker::StarWars.planet }
    association :project
  end
end
