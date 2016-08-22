require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before(:all) do
    @user = User.create({username: "Carson", email: "carson123@gmail.com", password: "password"})
    @unauthorized_user = User.create({username: "Pikachu", email: "pikachu@gmail.com", password: "password"})
  end

  describe "create user" do
    it "should create new user" do

    params = { user: {username: "Pokemon", email: "pokemon@gmail.com", password: "password"}}
    post :create, params: params

    user = User.find_by(email: "pokemon@gmail.com")
    expect(User.count).to eql(3)
    expect(user.email).to eql("pokemon@gmail.com")
    expect(user.username).to eql("Pokemon")
    expect(flash[:success]).to eql("You've created a new user.")
    end
  end

  describe "edit user" do

    it "should redirect if not logged in" do

      params = {id: @user.id}
      get :edit, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do

      params = { id: @user.id }
      get :edit, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should render edit" do

      params = { id: @user.id }
      get :edit, params: params, session: { id: @user.id }

      current_user = subject.send(:current_user)
      expect(subject).to render_template(:edit)
      expect(current_user).to be_present
    end
  end

  describe "update user" do

    it "should redirect if not logged in" do
      params = { id: @user.id, user: { email: "panda@gmail.com", username: "panda" } }
      patch :update, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { id: @user.id, user: { email: "tiger@gmail.com", username: "tiger" } }
      patch :update, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update user" do

      params = { id: @user.id, user: { email: "carson@gmail.com", username: "newusername", password: "newpassword" } }
      patch :update, params: params, session: { id: @user.id }

      @user.reload
      current_user = subject.send(:current_user).reload

      expect(current_user.email).to eql("carson@gmail.com")
      expect(current_user.username).to eql("newusername")
      expect(current_user.authenticate("newpassword")).to eql(@user)
    end
  end






end
