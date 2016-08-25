require 'rails_helper'

RSpec.describe TopicsController, type: :controller do

  before(:all) do
    @admin = create(:user, :admin)
    @user = create(:user, :sequenced_email)
    @topic = create (:topic)
  end

  describe "render index" do

    it "should render index" do

      get :index
      expect(subject).to render_template(:index)
      expect(Topic.count).to eql(1)
    end
  end

  describe "render new" do

    it "should render new" do
      get :new, session: {id: @admin.id}
      expect(subject).to render_template(:new)
    end
  end

  describe "create topic" do

    it "should create a new topic for admin" do
      params = {topic: {title: "Pikachu monster", description: "I am pikachu hahaha"}}
      post :create, params: params, session: {id: @admin.id}

      topic = Topic.find_by(title: "Pikachu monster", description: "I am pikachu hahaha")
      expect(topic.title).to eql("Pikachu monster")
      expect(topic.description).to eql("I am pikachu hahaha")
      expect(Topic.count).to eql(2)
      expect(subject).to redirect_to(topics_path)
      expect(flash[:success]).to eql("You've created a new topic.")
    end

    it "should deny if not logged in" do
      params = {topic: {title: "I am New", description: "Let me in"}}
      post :create, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should deny if user unauthorized" do

      params = {topic: {title: "I am New", description: "Let me in"}}
      post :create, params: params, session: {id: @user.id}

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end
  end

  describe "edit topic" do

    it "should deny if not logged in" do
      params = {id: @topic.id}
      get :edit, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should deny if user unauthorized" do
      params = {id: @topic.id}
      get :edit, params: params, session: {id: @user.id}

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "render edit topic" do
      params = {id: @topic.id}
      get :edit, params: params, session: {id: @admin.id}

      current_user = subject.send(:current_user)
      expect(subject).to render_template(:edit)
      expect(current_user).to be_present
    end
  end

  describe "update topic" do

    it "should deny if not logged in" do
      params = {id: @topic.id}
      patch :update, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should deny if user unauthorized" do
      params = {id: @topic.id, topic: {title: "New Pikachu", description: "Catch Me Pikachu"}}
      patch :update, params: params, session: {id: @user.id}

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update topic" do
      params = { id: @topic.id, topic: {title: "New Pikachu", description: "Catch Me Pikachu"}}
      patch :update, params: params, session: { id: @admin.id }

      @topic.reload

      expect(@topic.title).to eql("New Pikachu")
      expect(@topic.description).to eql("Catch Me Pikachu")
      expect(flash[:success]).to eql("You've edited a topic.")
    end
  end

    describe "destroy topic" do

      it "should deny if not logged in" do
        params = {id: @topic.id}
        delete :destroy, params: params

        expect(subject).to redirect_to(root_path)
        expect(flash[:danger]).to eql("You need to login first")
      end

      it "should deny if user unauthorized" do
        params = {id: @topic.id}
        delete :destroy, params: params, session: {id: @user.id}

        expect(subject).to redirect_to(root_path)
        expect(flash[:danger]).to eql("You're not authorized")
      end

      it "should delete topic" do
        params = {id: @topic.id}
        delete :destroy, params: params, session: {id: @admin.id }

        expect(Topic.count).to eql(0)
        expect(flash[:success]).to eql("You've deleted a topic.")
      end
    end











end
