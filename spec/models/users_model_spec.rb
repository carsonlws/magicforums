require 'rails_helper'

RSpec.describe User, type: :model do

  context "assocation" do
    it { should have_many(:posts) }
    it { should have_many(:comments) }
    it { should have_many(:votes) }
    it { should have_many(:topics) }
  end

  context "email validation" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end

  context "username validation" do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
  end

  context "slug callback" do
      it "should set slug" do
        user = create(:user)

        expect(user.slug).to eql(user.username.gsub(" ", "-"))
      end

      it "should update slug" do
        user = create(:user)

        user.update(username: "updatedname")

        expect(user.slug).to eql("updatedname")
      end
  end

end
