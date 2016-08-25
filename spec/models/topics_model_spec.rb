require 'rails_helper'

RSpec.describe Topic, type: :model do

  context "assocation" do
    it { should have_many(:posts) }
  end

  context "title" do
    it { should validate_presence_of(:title) }
  end

  context "description" do
    it { should validate_presence_of(:description) }
  end

  context "slug callback" do
      it "should set slug" do
        topic = create(:topic)

        expect(topic.slug).to eql(topic.title.gsub(" ", "-"))
      end

      it "should update slug" do
        topic = create(:topic)

        topic.update(title: "updatedname")

        expect(topic.slug).to eql("updatedname")
      end
  end

end
