class CommentsController < ApplicationController
  respond_to :js
  before_action :authenticate!, only: [:index]

  def index
    @post = Post.includes(:comments).find_by(id: params[:post_id])
    @topic = @post.topic
    @comments = @post.comments.order("created_at DESC")
  end

  def new
    @post = Post.find_by(id: params[:post_id])
    @topic = @post.topic
    @comment = Comment.new
  end

  def create
    @post = Post.find_by(id: params[:post_id])
    @topic = @post.topic
    @comment = current_user.comments.build(comment_params.merge(post_id: params[:post_id]))

    if @comment.save
      redirect_to topic_post_comments_path(@topic, @post)
      flash[:success] = "You've created a new topic."
    else
      redirect_to new_topic_post_comment_path(@topic, @post)
      flash[:danger] = @comment.errors.full_messages
    end
  end

  def edit
    @post = Post.find_by(id: params[:post_id])
    @topic = @post.topic
    @comment = Comment.find_by(id: params[:id])
    authorize @comment
  end

  def update
    @post = Post.find_by(id: params[:post_id])
    @topic = @post.topic
    @comment = Comment.find_by(id: params[:id])

    if @comment.update(comment_params)
      redirect_to topic_post_comments_path(@topic, @post)
    else
      redirect_to edit_topic_post_comment_path(@topic, @post, @comment)
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    @topic = @comment.post.topic
    authorize @comment

    if @comment.destroy
      redirect_to topic_post_comments_path(@topic, @post)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:title, :body, :image)
  end


end
