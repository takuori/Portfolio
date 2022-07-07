class Public::LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    like = current_member.likes.new(post_id: @post.id)
    like.save
  end

  def destroy
    @post = Post.find(params[:post_id])
    like = current_member.likes.find_by(post_id: @post.id)
    like.destroy
  end

  private

end
