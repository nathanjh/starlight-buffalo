FactoryGirl.define do
  factory :image_comment, class: 'Comment' do
    body { Faker::ChuckNorris.fact }
    association :commentable, factory: :image
    association :user
  end

  factory :post_comment, class: 'Comment' do
    body { Faker::ChuckNorris.fact }
    association :commentable, factory: :post
    association :user
  end
end
