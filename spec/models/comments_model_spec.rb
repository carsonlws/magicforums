require 'rails_helper'

RSpec.describe Comment, type: :model do

  context "assocation" do
    it { should have_many(:votes) }
    it { should belong_to(:post)}
    it { should belong_to(:user)}
  end

  context "body" do
    it { should validate_presence_of(:body) }
  end

  context "total votes" do
    it "should give 0 if no votes" do
      comment = create(:comment)

      expect(comment.total_votes).to eql(0)
    end

    it "should calculate the correct vote score" do
      comment = create(:comment)
      user = create(:user)

      # Creates 6(+1), 4(-1) votes
      10.times.each { |x| user.votes.create(comment_id: comment.id, value: x % 3 == 0 ? -1 : 1 )}

      expect(comment.total_votes).to eql(2)
    end
  end  
end
