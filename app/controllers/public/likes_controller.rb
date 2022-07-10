class Public::LikesController < ApplicationController
  before_action :authenticate_member!
  
  def create
    @post = Post.find(params[:post_id])
    like = Like.new(member_id: current_member.id, post_id: params[:post_id])
    like.save
  end

  def destroy
    @post = Post.find(params[:post_id])
    like = Like.find_by(member_id: current_member.id, post_id: params[:post_id])
    like.destroy
  end

  private

end
