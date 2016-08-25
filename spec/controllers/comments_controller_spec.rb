require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  before(:all) do
    @admin = create(:user, :admin)
    @user = create(:user, :sequenced_email, :sequenced_username)
    @unauthorized_user = create(:user, :sequenced_email)
    @topic = create(:topic)
    @post = create(:post, user_id: @user.id, topic_id: @topic.id)
    @comment = create(:comment, post_id: @post.id)
  end

  describe "render index" do

    it "should render index" do
      params = { topic_id: @topic.id, post_id: @post.id }
      get :index, params: params

      expect(subject).to render_template(:index)
      expect(assigns[:comments].count).to eql(1)
    end
  end

  describe "create comment" do

    it "should deny if not logged in" do
      params = { topic_id: @topic.id, post_id: @post.id, comment: { body: "my comment testing" } }
      post :create, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should create a new comment" do
      params = { topic_id: @topic.id, post_id: @post.id, comment: { body: "my comment testing" } }
      post :create, xhr: true, params: params, session: {id: @user.id}

      comment = Comment.find_by(body: "my comment testing")
      expect(comment.body).to eql("my comment testing")
      expect(Comment.count).to eql(2)
      expect(flash[:success]).to eql("Comment created")
    end
  end

  describe "edit comment" do

    it "should deny if not logged in" do
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      get :edit, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should deny if user unauthorized" do
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      get :edit, params: params, session: {id: @unauthorized_user.id}

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "render edit comment" do
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      get :edit, xhr: true, params: params, session: {id: @admin.id}

      current_user = subject.send(:current_user)
      expect(current_user).to eql(@admin)
      expect(subject).to render_template(:edit)
      expect(current_user).to be_present
    end
  end

  describe "update comment" do

    it "should deny if not logged in" do
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      patch :update, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should deny if user unauthorized" do
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id}
      patch :update, params: params, session: {id: @unauthorized_user.id}

      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update comment" do
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id, comment: { body: "my comment testing" } }
      patch :update, xhr: true, params: params, session: { id: @admin.id }

      @comment.reload

      expect(@comment.body).to eql("my comment testing")
      expect(flash[:success]).to eql("Comment updated")
    end
  end

  describe "destroy comment" do

    it "should deny if not logged in" do
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      delete :destroy, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should deny if user unauthorized" do
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      delete :destroy, params: params, session: {id: @unauthorized_user.id}

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should delete post" do
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      delete :destroy, xhr: true, params: params, session: {id: @admin.id }

      expect(Comment.count).to eql(0)
      expect(flash[:success]).to eql("Comment deleted")
    end
  end

end
