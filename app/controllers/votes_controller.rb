class VotesController < ApplicationController
  # respond_to :js
  before_action :authenticate!, only: [:upvote, :downvote]

  def upvote
    @comment = Comment.find_by(id: params[:comment_id])
    @post = @comment.post
    @topic = @post.topic
    @vote = current_user.votes.find_or_create_by(comment_id: params[:comment_id])

    if @vote
        @vote.update(value: +1)
      flash[:success] = "Vote submitted +1"
      redirect_to topic_post_comments_path(@topic, @post)
    end
  end


  def downvote
    @comment = Comment.find_by(id: params[:comment_id])
    @post = @comment.post
    @topic = @post.topic
    @vote = current_user.votes.find_or_create_by(comment_id: params[:comment_id])

    if @vote
        @vote.update(value: -1)
      flash[:danger] = "Vote submitted -1"
      redirect_to topic_post_comments_path(@topic, @post)
    end
  end
end
