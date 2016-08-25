FactoryGirl.define do

  factory :topic do
    title "Pokemon"
    description "Catch Pokemon at magic"

    trait :sequenced_title do
      sequence(:title) { |n| "My topic title No #{n}" }
    end

    trait :sequenced_description do
      sequence(:description) { |n| "My description for topic #{n}" }
    end

    trait :admin do
      role :admin
      sequence(:email) { |n| "admin#{n}@email.com" }
      sequence(:username) { |n| "admin#{n}" }
    end
  end
end
