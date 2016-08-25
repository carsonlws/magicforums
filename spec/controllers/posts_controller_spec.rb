require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  before(:all) do
    @admin = User.create({username: "Admin", email: "carson1@gmail.com", password: "password", role: "admin"})
    @user = User.create({username: "User", email: "user@gmail.com", password: "password", role: "user"})
    @unauthorized_user = User.create({username: "Pikachu", email: "pikachu@gmail.com", password: "password"})
    @topic = Topic.create ({title: "Catch pokemon", description: "pikachu pikachu", user_id: @admin.id})
    @post = Post.create ({title: "My Post New Title", body: "My New Post Body", user_id: @user.id, topic_id: @topic.id})
  end

  describe "render index" do

    it "should render index" do
      params = { topic_id: @topic.id }
      get :index, params: params

      expect(subject).to render_template(:index)
      expect(assigns[:posts].count).to eql(1)
    end
  end

  describe "render new" do

    it "should render new" do
      params = { topic_id: @topic.id }
      get :new, params: params, session: {id: @user.id}
      expect(subject).to render_template(:new)
    end
  end

  describe "create post" do

    it "should deny if not logged in" do
      params = {topic_id: @topic.id, post: {title: "I am New", body: "Let me in"}}
      post :create, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should create a new post" do
      params = {topic_id: @topic.id, post: {title: "Pikachu monster", body: "I am pikachu hahaha"}}
      post :create, params: params, session: {id: @user.id}

      post = Post.find_by(title: "Pikachu monster")
      expect(post.title).to eql("Pikachu monster")
      expect(post.body).to eql("I am pikachu hahaha")
      expect(Post.count).to eql(2)
      expect(subject).to redirect_to(topic_posts_path(post.topic))
      expect(flash[:success]).to eql("You've created a new post.")
    end
  end

  describe "edit topic" do

    it "should deny if not logged in" do
      params = { topic_id: @topic.id, id: @post.id }
      get :edit, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should deny if user unauthorized" do
      params = { topic_id: @topic.id, id: @post.id }
      get :edit, params: params, session: {id: @unauthorized_user.id}

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "render edit post" do
      params = {topic_id: @topic.id, id: @post.id }
      get :edit, params: params, session: {id: @admin.id}

      current_user = subject.send(:current_user)
      expect(subject).to render_template(:edit)
      expect(current_user).to be_present
    end
  end

  describe "update topic" do

    it "should deny if not logged in" do
      params = { topic_id: @topic.id, id: @post.id }
      patch :update, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should deny if user unauthorized" do
      params = { topic_id: @topic.id, id: @post.id }
      patch :update, params: params, session: {id: @unauthorized_user.id}

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update post" do
      params = {topic_id: @topic.id, id: @post.id, post: {title: "Pikachu monster", body: "I am pikachu hahaha"}}
      patch :update, params: params, session: { id: @admin.id }

      @post.reload

      expect(@post.title).to eql("Pikachu monster")
      expect(@post.body).to eql("I am pikachu hahaha")
      expect(flash[:success]).to eql("You've updated a post.")
      expect(subject).to redirect_to(topic_posts_path(@topic))

    end
  end

    describe "destroy post" do

      it "should deny if not logged in" do
        params = { topic_id: @topic.id, id: @post.id }
        delete :destroy, params: params

        expect(subject).to redirect_to(root_path)
        expect(flash[:danger]).to eql("You need to login first")
      end

      it "should deny if user unauthorized" do
        params = { topic_id: @topic.id, id: @post.id }
        delete :destroy, params: params, session: {id: @unauthorized_user.id}

        expect(subject).to redirect_to(root_path)
        expect(flash[:danger]).to eql("You're not authorized")
      end

      it "should delete post" do
        params = {topic_id: @topic.id, id: @post.id}
        delete :destroy, params: params, session: {id: @admin.id }

        expect(Post.count).to eql(0)
        expect(flash[:success]).to eql("Post deleted")
        expect(subject).to redirect_to(topic_posts_path(@topic))
      end
    end

end
