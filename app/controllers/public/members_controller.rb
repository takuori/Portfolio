class Public::MembersController < ApplicationController
  def show
    @member = current_member
    @posts = Post.where(member_id: current_member.id).includes(:member).order("created_at DESC")
  end

  def edit
    @member = current_member
  end

  def update
    @member = Menber.find(params[:id])
    if @member.update
       flash[:notice] = "変更内容更新いたしました"
       redirect_to edit_members_path
    else
       flash[:alert] = "変更内容の更新に失敗しました"
       render 'edit'
    end
  end

  def withdraw
    @member = Member.find(params[:id])
    @member.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理いたしました"
    redirect_to new_member_registration_path
  end
end
