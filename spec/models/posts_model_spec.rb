require 'rails_helper'

RSpec.describe Post, type: :model do

  context "assocation" do
    it { should have_many(:comments) }
    it { should belong_to(:topic)}
    it { should belong_to(:user)}
  end

  context "title" do
    it { should validate_presence_of(:title) }
  end

  context "body" do
    it { should validate_presence_of(:body) }
  end

  context "slug callback" do
      it "should set slug" do
        post = create(:post)

        expect(post.slug).to eql(post.title.gsub(" ", "-"))
      end

      it "should update slug" do
        post = create(:post)

        post.update(title: "updatedname")

        expect(post.slug).to eql("updatedname")
      end
  end

end
