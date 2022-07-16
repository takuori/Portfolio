class Public::PostsController < ApplicationController
  before_action :authenticate_member!

  def new
    @post = Post.new
    @post.tag_posts.build
  end

  def index
    @tag_list = Tag.all
    @posts = Post.where(status: :released)
    if params[:new]
      @posts = Post.latest.page(params[:page]).per(20)
    elsif params[:old]
      @posts = Post.old.page(params[:page]).per(20)
    elsif params[:like]
      posts = Post.like_count
      @posts = Kaminari.paginate_array(posts).page(params[:page]).per(20)
    end
  end

  def show
    @post = Post.find(params[:id])
    @tag_posts = @post.tags
    @comment = Comment.new
    @comments = @post.comments.page(params[:page]).per(10)
    @member = current_member
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
  end

  def create
    @post = Post.new(post_params)
    @post.member_id = current_member.id
    tag_list = params[:post][:name].split(",")

    if tag_list == []
      tag = Tag.new()
      tag.name = ""
      tag.save
      @member = current_member
      flash[:alert] = "投稿に失敗しました"
      render :new
    elsif @post.save
      @post.tags_save(tag_list)
      flash[:notice] = "投稿されました"
      redirect_to posts_path
    else
      @member = current_member
      flash[:alert] = "投稿に失敗しました"
      render :new
    end
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:name].split(',')

    if tag_list == []
      tag = Tag.new()
      tag.name = ""
      tag.save
      @member = current_member
      flash[:alert] = "投稿に失敗しました"
      render :new
    elsif @post.update(post_params)
      @post.tags_save(tag_list)
      flash[:notice] = "投稿されました"
      redirect_to posts_path
    else
      @member = current_member
      flash[:alert] = "投稿に失敗しました"
      render :new
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
    params.require(:post).permit(:location, :detail, :post_image, :status, {tag_ids: []}).merge(member_id: current_member.id)
  end
end
