class Public::PostsController < ApplicationController
  
  def new
    @post = Post.new
    @post.tag_posts.build
  end

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

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
  end

  def create
    @post = Post.new(post_params)
    @post.member_id = current_member.id
    tag_list = params[:post][:name].split(",")
    if @post.save
      @post.tags_save(tag_list)
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:name].split(',')
    if @post.update(post_params)
       @post.tags_save(tag_list)
       redirect_to post_path(@post.id),notice: '更新完了いたしました'
    else
       render :edit
    end
  end

  def search
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @posts = @tag.posts.all
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      redirect_to posts_path, notice: '削除しました'
    else
      render :edit
    end
  end

  private

  def post_params
    params.require(:post).permit(:location, :detail, :post_image, {tag_ids: []}).merge(member_id: current_member.id)
  end
end
