require 'rails_helper'

RSpec.describe TopicsController, type: :controller do

  before(:all) do
    @admin = User.create({username: "Admin", email: "carson123@gmail.com", password: "password", role: "admin"})
    @user = User.create({username: "User", email: "user@gmail.com", password: "password", role: "user"})
    @topic = Topic.create ({title: "Catch pokemon", description: "pikachu pikachu", user_id: @admin.id})
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

      get :new
      binding.pry
      expect(subject).to render_template(:new)
      expect(assigns[:topic]).to be_present
    end
  end









end
