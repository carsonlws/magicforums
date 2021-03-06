class PostsController < ApplicationController

  respond_to :js
  before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]

  def index
    @topic = Topic.includes(:posts).friendly.find(params[:topic_id])
    @posts = @topic.posts.order("created_at DESC").page(params[:page]).per(3)
  end

  def new
    @topic = Topic.friendly.find(params[:topic_id])
    @post = Post.new
  end

  def create
    @topic = Topic.friendly.find(params[:topic_id])
    @post = current_user.posts.build(post_params)
    @post.topic_id = @topic.id

    if @post.save
      flash[:success] = "You've created a new post."
      redirect_to topic_posts_path(@topic)
    else
      flash[:danger] = @post.errors.full_messages
      redirect_to new_topic_post_path(@topic)
    end
  end

  def edit
     @post = Post.friendly.find(params[:id])
     @topic = @post.topic
     authorize @post
  end

  def update
    @topic = Topic.friendly.find(params[:topic_id])
    @post = Post.friendly.find(params[:id])
    authorize @post

    if @post.update(post_params)
      redirect_to topic_posts_path(@topic)
      flash[:success] = "You've updated a post."
    else
      redirect_to edit_topic_post_path(@topic, @post)
      flash[:danger] = @post.errors.full_messages
    end
  end

  def destroy
    @post = Post.friendly.find(params[:id])
    @topic = @post.topic
    authorize @post
    # find the post by post id, assign the post back to id

    if @post.destroy
      flash[:success] = "Post deleted"
      redirect_to topic_posts_path(@topic)
    end
  end

  private

    def post_params
      params.require(:post).permit(:title, :body, :image)
    end

end
