class Public::MembersController < ApplicationController
  before_action :authenticate_member!
  def show
    @member = current_member
    @posts = Post.where(member_id: current_member.id, status: 0).includes(:member).order("created_at DESC")
  end

  def edit
    @member = current_member
  end

  def update
    @member = Member.find(params[:id])
    if @member.update
       flash[:success] = "変更内容更新いたしました"
       redirect_to edit_members_path
    else
       flash[:danger] = "変更内容の更新に失敗しました"
       render 'edit'
    end
  end

  def likes
    likes = Like.where(member_id: current_member.id).pluck(:post_id)
    @like_posts = Post.find(likes)
  end

  def confirm
    @member = current_member
    @posts = @member.posts.where(status: 1).order('created_at DESC')
  end

  def withdraw
    @member = Member.find(params[:id])
    @member.update(is_deleted: true)
    reset_session
    flash[:danger] = "退会処理いたしました"
    redirect_to new_member_registration_path
  end
end
