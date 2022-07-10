class Public::SearchesController < ApplicationController
  before_action :authenticate_member! 
  
  def search
    @posts = Post.looks(params[:search], params[:word])
  end
end
