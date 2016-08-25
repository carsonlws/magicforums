require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  before(:all) do
    @admin = User.create({username: "Admin", email: "carson1@gmail.com", password: "password", role: "admin"})
    @user = User.create({username: "User", email: "user@gmail.com", password: "password2", role: "user"})
    @topic = Topic.create ({title: "Catch pokemon", description: "pikachu haha pikachu", user_id: @admin.id})
    @post = Post.create ({title: "My Post New Title", body: "My New Post Body aaaaaaaaaaaaaaaa Body", user_id: @user.id, topic_id: @topic.id})
    @comment = Comment.create ({body: "My New Comment Body ha", user_id: @user.id, post_id: @post.id})
    # @vote = Vote.create ({value: 0, user_id: @user.id, comment_id: @comment.id})
  end

  describe "upvote comment" do
      it "should deny if not logged in" do
      params = {id: @comment.id}
      post :upvote, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should create vote if non-existant" do
      params = {comment_id: @comment.id}
      expect(Vote.count).to eql(0)
      post :upvote, params: params, session: {id: @user.id}

      expect(Vote.count).to eql(1)
      expect(Vote.first.user).to eql(@user)
      expect(assigns[:vote]).to_not be_nil
    end

    it "should find vote if existant" do
      @vote = @user.votes.create(comment_id: @comment.id)
      expect(Vote.count).to eql(1)
      params = {comment_id: @comment.id}

      post :upvote, params: params, session: {id: @user.id}
      expect(Vote.count).to eql(1)
      expect(Vote.first.user).to eql(@user)
      # // :vote refer to controller method, but @vote is for the instance varice here
      expect(assigns[:vote]).to eql(@vote)
    end

    it "Should be +1" do
      params = {comment_id: @comment.id}
      post :upvote, params: params, session: {id: @user.id}

      expect(Vote.count).to eql(1)
      expect(assigns[:vote].value).to eql(1)
    end
  end

  describe "downvote comment" do

    it "should deny if not logged in" do
      params = {id: @comment.id}
      post :downvote, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should create vote if non-existant" do
      params = {comment_id: @comment.id}
      expect(Vote.count).to eql(0)
      post :downvote, params: params, session: {id: @user.id}

      expect(Vote.count).to eql(1)
      expect(Vote.first.user).to eql(@user)
      expect(assigns[:vote]).to_not be_nil
    end

    it "should find vote if existant" do
      @vote = @user.votes.create(comment_id: @comment.id)
      expect(Vote.count).to eql(1)
      params = {comment_id: @comment.id}

      post :downvote, params: params, session: {id: @user.id}
      expect(Vote.count).to eql(1)
      expect(Vote.first.user).to eql(@user)
      # // :vote refer to controller method, but @vote is for the instance varice here
      expect(assigns[:vote]).to eql(@vote)
    end

    it "Should be -1" do
      params = {comment_id: @comment.id}
      post :downvote, params: params, session: {id: @user.id}

      expect(Vote.count).to eql(1)
      expect(assigns[:vote].value).to eql(-1)
      expect(Vote.first.value).to eql(-1)
    end
  end

end
