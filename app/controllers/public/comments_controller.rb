class Public::CommentsController < ApplicationController
  before_action :authenticate_member!
  
  def create
    @post = Post.find(params[:post_id])
    @comment = current_member.comments.new(comment_params)
    @comment.post_id = @post.id
    if @comment.save
      flash[:notice] = "コメントを投稿しました"
      @post.create_notification_comment!(current_member, @comment.id)
      respond_to :js
    end

  end

  def destroy
    @comment = Comment.find_by(id: params[:id], post_id: params[:post_id])
    if @comment.destroy
     flash[:alert] = "コメントを削除しました"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
