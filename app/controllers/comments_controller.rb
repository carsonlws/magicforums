class CommentsController < ApplicationController
  respond_to :js
  before_action :authenticate!, only: [:create, :edit, :update, :destroy]

  def index
    @post = Post.includes(:comments).friendly.find(params[:post_id])
    @topic = @post.topic
    @comments = @post.comments.order("created_at DESC").page(params[:page]).per(5)
    @comment = Comment.new

  end

  def create
    @post = Post.friendly.find(params[:post_id])
    @topic = @post.topic
    @comment = current_user.comments.build(comment_params.merge(post_id: @post.id))
    @new_comment = Comment.new

    if @comment.save
      CommentBroadcastJob.perform_later("create", @comment)
      flash.now[:success] = "Comment created"
    else
      flash.now[:danger] = @comment.errors.full_messages
    end
  end

  def edit
    @post = Post.friendly.find(params[:post_id])
    @topic = @post.topic
    @comment = Comment.find_by(id: params[:id])
    authorize @comment
  end

  def update
    @post = Post.friendly.find(params[:post_id])
    @topic = @post.topic
    @comment = Comment.find_by(id: params[:id])
    authorize @comment

    if @comment.update(comment_params)
      CommentBroadcastJob.perform_now("update", @comment)
      # redirect_to topic_post_comments_path(@topic, @post)
      flash.now[:success] = "Comment updated"
    else
      # redirect_to edit_topic_post_comment_path(@topic, @post, @comment)
      flash.now[:danger] = @comment.errors.full_messages
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    @topic = @comment.post.topic
    authorize @comment

    if @comment.destroy
      CommentBroadcastJob.perform_now("destroy", @comment)
      flash.now[:success] = "Comment deleted"
      redirect_to topic_post_comments_path(@topic, @post)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:title, :body, :image)
  end


end
