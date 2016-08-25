FactoryGirl.define do

  factory :comment do
    body "The factory comment body"
    user_id { create(:user, :sequenced_email, :sequenced_username).id }
    post_id { create(:post).id }

    trait :sequenced_body do
      sequence(:body) { |n| "comments body haha #{n}" }
    end
  end
end
