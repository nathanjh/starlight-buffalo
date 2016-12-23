FactoryGirl.define do
  factory :image do
    title { Faker::Hipster.word }
    note { Faker::StarWars.quote }
    image_url { Faker::Internet.url }
    association :chapter
    association :project
  end
end
