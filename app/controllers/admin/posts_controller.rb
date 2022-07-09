class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @tag_list = Tag.all
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @tag_posts = @post.tags
    @comment = Comment.new
    @comments = @post.comments.page(params[:page]).per(10)
  end

  def search
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @posts = @tag.posts.all
  end

end
