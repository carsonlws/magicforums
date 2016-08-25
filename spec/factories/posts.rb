FactoryGirl.define do

  factory :post do
    title "My Post"
    body "Catch Pokemon post body"
    user_id { create(:user, :sequenced_email, :sequenced_username).id }
    topic_id { create(:topic).id }

    trait :sequenced_title do
      sequence(:title) { |n| "My body title No #{n}" }
    end

    trait :sequenced_body do
      sequence(:body) { |n| "My description for post #{n}" }
    end
  end
end
