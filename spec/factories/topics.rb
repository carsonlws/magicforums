FactoryGirl.define do

  factory :topic do
    title "Pokemon"
    description "Catch Pokemon at magic"
    user_id { create(:user, :admin).id }

    trait :sequenced_title do
      sequence(:title) { |n| "My topic title No #{n}" }
    end

    trait :sequenced_description do
      sequence(:description) { |n| "My description for topic #{n}" }
    end
  end
end
